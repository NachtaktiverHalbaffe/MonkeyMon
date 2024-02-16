import 'package:monkey_mon/src/data/repository/pokemon_repository_impl.dart';
import 'package:monkey_mon/src/domain/repository/pokemon_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_pokemon.g.dart';

@riverpod
class DeletePokemon extends _$DeletePokemon {
  late PokemonRepository repository;

  @override
  Future<bool> build({int? id, String? pokemonName}) async {
    repository = ref.read(pokemonRepositoryImplProvider.notifier);
    return await repository.deletePokemon(id: id, name: pokemonName);
  }
}
