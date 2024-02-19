import 'package:cancellation_token/cancellation_token.dart';
import 'package:monkey_mon/src/core/utils/internet_connection_checker.dart';
import 'package:monkey_mon/src/data/datasources/app_database.dart';
import 'package:monkey_mon/src/data/datasources/pokemon_remote_datasource.dart';
import 'package:monkey_mon/src/data/mapper/pokemon_mapper.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';
import 'package:monkey_mon/src/domain/repository/pokemon_repository.dart';
import 'package:monkey_mon/src/exceptions/network_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "pokemon_repository_impl.g.dart";

@riverpod
class PokemonRepositoryImpl extends _$PokemonRepositoryImpl
    implements PokemonRepository {
  late final AppDatabase database = ref.read(databaseProvider);
  late final InternetConnectionChecker internetConnectionChecker =
      ref.read(internetConnectionCheckerProvider.notifier);
  late final PokemonRemoteDatasource remoteDatasource =
      ref.read(pokemonRemoteDatasourceProvider);

  @override
  Stream<PokemonDto> build() {
    return streamAllPokemon();
  }

  @override
  Future<PokemonDto?> createPokemon(PokemonDto pokemonDto) async {
    final PokemonsCompanion companion = PokemonMapper.mapFromDto(pokemonDto);

    final Pokemon? result = await database.pokemonsDao.createPokemon(companion);

    return result != null ? PokemonMapper.mapToDto(result) : null;
  }

  @override
  Future<bool> deletePokemon({int? id, String? name}) async {
    if (((id == null && name == null) || (id != null && name != null))) {
      throw ArgumentError(
          "Both id and name are not specified. Either one needs to be given");
    }
    int nrDeletedEntries;
    if (id != null) {
      nrDeletedEntries = await database.pokemonsDao.deletePokemon(id);
    } else {
      nrDeletedEntries = await database.pokemonsDao.deletePokemonByName(name!);
    }

    return nrDeletedEntries >= 1 ? true : false;
  }

  @override
  Future<List<PokemonDto>> getAllPokemon() async {
    List<Pokemon> pokemons = await database.pokemonsDao.getAllPokemon();
    var (needRemoteApiFetching, offset) = await computeOffset();

    if (needRemoteApiFetching &&
        await internetConnectionChecker.isConnected()) {
      List<Pokemon> remotePokemons = List.empty(growable: true);
      try {
        remotePokemons = await remoteDatasource.getAllPokemon(
            offset: offset != 0 ? offset : null);
      } on NetworkExcpetion {
        return List.empty();
      }

      if (remotePokemons.isNotEmpty) {
        for (Pokemon pokemon in remotePokemons) {
          await database.pokemonsDao
              .createPokemon(PokemonMapper.mapToCompanion(pokemon));
          pokemons.add(pokemon);
        }
      }
    }

    return PokemonMapper.mapToDtoList(pokemons);
  }

  @override
  Future<int> getNrOfCachedPokemon() async {
    return await database.pokemonsDao.getNrOfPokemon();
  }

  @override
  Future<PokemonDto?> getPokemon({int? id, String? name}) async {
    if ((id == null && name == null) || (id != null && name != null)) {
      throw ArgumentError(
          "Both id and name are not specified. Either one needs to be given");
    }
    Pokemon? pokemon;
    if (id != null) {
      pokemon = await database.pokemonsDao.getPokemon(id);
    } else {
      pokemon = await database.pokemonsDao.getPokemonByName(name!);
    }

    if (pokemon == null && await internetConnectionChecker.isConnected()) {
      pokemon = await remoteDatasource.getPokemon(id: id, name: name);
    }

    return pokemon != null ? PokemonMapper.mapToDto(pokemon) : null;
  }

  @override
  Stream<PokemonDto> streamAllPokemon(
      {CancellationToken? cancellationToken}) async* {
    var (needRemoteApiFetching, offset) = await computeOffset();
    List<Pokemon> pokemons = await database.pokemonsDao.getAllPokemon();

    for (Pokemon pokemon in pokemons) {
      if (cancellationToken != null) {
        if (cancellationToken.isCancelled) {
          return;
        }
      }

      await Future.delayed(const Duration(milliseconds: 20));
      yield PokemonMapper.mapToDto(pokemon);
    }

    if (needRemoteApiFetching &&
        await internetConnectionChecker.isConnected()) {
      final stream = remoteDatasource.streamAllPokemon(
          offset: offset, cancellationToken: cancellationToken);
      try {
        await for (final Pokemon remotePokemon in stream) {
          // Cache result
          await database.pokemonsDao
              .createPokemon(PokemonMapper.mapToCompanion(remotePokemon));

          yield PokemonMapper.mapToDto(remotePokemon);
        }
      } on NetworkExcpetion {
        return;
      }
    }
  }

  @override
  Future<PokemonDto?> updatePokemon(PokemonDto pokemonDto) async {
    final Pokemon? pokemon = await database.pokemonsDao
        .updatePokemon(PokemonMapper.mapFromDto(pokemonDto));

    return pokemon != null ? PokemonMapper.mapToDto(pokemon) : null;
  }

  ///
  /// Returns:
  ///   bool: If there are more Pokemon available in Remote api than the cached ones
  ///   int: The offset from which the remote datasource must start getting data to get up to date
  @override
  Future<(bool, int)> computeOffset() async {
    int nrCachedItems = await database.pokemonsDao.getNrOfPokemon();
    int nrAvailableRemoteItems = 0;
    try {
      nrAvailableRemoteItems = await remoteDatasource.getNrOfTotalPokemon();
    } on Exception {
      return (false, 0);
    }

    return nrCachedItems < nrAvailableRemoteItems
        ? (true, nrCachedItems)
        : (false, 0);
  }
}
