import 'package:cancellation_token/cancellation_token.dart';
import 'package:monkey_mon/src/data/repository/pokemon_repository_impl.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';
import 'package:monkey_mon/src/domain/repository/pokemon_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "load_pokemons_oneshot.g.dart";

@riverpod
class LoadPokemonsOneshot extends _$LoadPokemonsOneshot {
  @override
  Future<List<PokemonDto>> build() async {
    PokemonRepository repository =
        ref.read(pokemonRepositoryImplProvider.notifier);

    return await repository.getAllPokemon();
  }
}
