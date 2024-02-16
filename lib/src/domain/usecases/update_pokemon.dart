import 'package:monkey_mon/src/data/repository/pokemon_repository_impl.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';
import 'package:monkey_mon/src/domain/repository/pokemon_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_pokemon.g.dart';

@riverpod
class UpdatePokemon extends _$UpdatePokemon {
  late PokemonRepository repository;

  @override
  Future<PokemonDto?> build(PokemonDto pokemonDto) async {
    repository = ref.read(pokemonRepositoryImplProvider.notifier);
    return await repository.updatePokemon(pokemonDto);
  }
}
