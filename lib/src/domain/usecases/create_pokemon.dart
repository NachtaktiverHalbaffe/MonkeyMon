import 'package:monkey_mon/src/data/repository/pokemon_repository_impl.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';
import 'package:monkey_mon/src/domain/repository/pokemon_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "create_pokemon.g.dart";

@riverpod
class CreatePokemon extends _$CreatePokemon {
  late final PokemonRepository repository;

  @override
  Future<PokemonDto?> build(PokemonDto pokemon) async {
    repository = ref.read(pokemonRepositoryImplProvider.notifier);
    return await repository.createPokemon(pokemon);
  }
}
