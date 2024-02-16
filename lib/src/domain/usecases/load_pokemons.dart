import 'package:cancellation_token/cancellation_token.dart';
import 'package:monkey_mon/src/data/repository/pokemon_repository_impl.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';
import 'package:monkey_mon/src/domain/repository/pokemon_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "load_pokemons.g.dart";

@riverpod
class LoadPokemons extends _$LoadPokemons {
  late final PokemonRepository repository;

  @override
  Stream<PokemonDto> build({CancellationToken? cancellationToken}) {
    repository = ref.read(pokemonRepositoryImplProvider.notifier);
    return repository.streamAllPokemon(cancellationToken: cancellationToken);
  }

  Future<List<PokemonDto>> loadPokemonOneshot() async {
    return await repository.getAllPokemon();
  }
}
