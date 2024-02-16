import 'package:cancellation_token/cancellation_token.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';

abstract class PokemonRepository {
  Future<PokemonDto?> createPokemon(PokemonDto pokemonDto);

  Future<List<PokemonDto>> getAllPokemon();

  Stream<PokemonDto> streamAllPokemon({CancellationToken? cancellationToken});

  Future<int> getNrOfCachedPokemon();

  Future<PokemonDto?> getPokemon({int? id, String? name});

  Future<PokemonDto?> updatePokemon(PokemonDto pokemonDto);

  Future<bool> deletePokemon({int? id, String? name});

  Future<(bool, int)> computeOffset();
}
