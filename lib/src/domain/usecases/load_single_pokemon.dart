import 'package:monkey_mon/src/data/repository/pokemon_repository_impl.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';
import 'package:monkey_mon/src/domain/repository/pokemon_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "load_single_pokemon.g.dart";

@riverpod
class LoadSinglePokemon extends _$LoadSinglePokemon {
  late final PokemonRepository repository;

  @override
  Future<PokemonDto?> build({int? id, String? pokemonName}) async {
    repository = ref.read(pokemonRepositoryImplProvider.notifier);
    return await repository.getPokemon(id: id, name: pokemonName);
  }
}
