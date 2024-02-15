import 'package:drift/drift.dart';
import 'package:monkey_mon/src/data/datasources/app_database.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';

class PokemonMapper {
  static PokemonDto mapToDto(Pokemon pokemon) {
    return PokemonDto(
        id: pokemon.id,
        name: pokemon.name,
        description: pokemon.description,
        sprites: pokemon.sprites,
        attack: pokemon.attack,
        defense: pokemon.defense,
        specialAttack: pokemon.specialAttack,
        specialDefense: pokemon.specialDefense,
        speed: pokemon.speed,
        hp: pokemon.hp,
        types: pokemon.types);
  }

  static List<PokemonDto> mapToDtoList(List<Pokemon> pokemons) {
    List<PokemonDto> list = List.empty(growable: true);

    for (Pokemon pokemon in pokemons) {
      list.add(mapToDto(pokemon));
    }

    return list;
  }

  static PokemonsCompanion mapFromDto(PokemonDto pokemonDto) {
    return PokemonsCompanion(
      id: Value<int>(pokemonDto.id),
      name: Value<String>(pokemonDto.name),
      description: Value<String?>(pokemonDto.description),
      sprites: Value<PokemonSprites?>(pokemonDto.sprites),
      attack: Value<int>(pokemonDto.attack),
      defense: Value<int>(pokemonDto.defense),
      specialAttack: Value<int>(pokemonDto.specialAttack),
      specialDefense: Value<int>(pokemonDto.specialDefense),
      speed: Value<int>(pokemonDto.speed),
      hp: Value<int>(pokemonDto.hp),
      types: Value<List<String>>(pokemonDto.types),
    );
  }

  static List<PokemonsCompanion> mapFromDtoList(List<PokemonDto> pokemonDtos) {
    List<PokemonsCompanion> list = List.empty(growable: true);

    for (PokemonDto pokemonDto in pokemonDtos) {
      list.add(mapFromDto(pokemonDto));
    }

    return list;
  }

  static PokemonsCompanion mapToCompanion(Pokemon pokemon) {
    return PokemonsCompanion(
        id: Value<int>(pokemon.id),
        name: Value<String>(pokemon.name),
        description: Value<String?>(pokemon.description),
        sprites: Value<PokemonSprites?>(pokemon.sprites),
        attack: Value<int>(pokemon.attack),
        defense: Value<int>(pokemon.defense),
        specialAttack: Value<int>(pokemon.specialAttack),
        specialDefense: Value<int>(pokemon.specialDefense),
        speed: Value<int>(pokemon.speed),
        hp: Value<int>(pokemon.hp),
        types: Value<List<String>>(pokemon.types));
  }

  static List<PokemonsCompanion> mapToCompanionList(List<Pokemon> pokemons) {
    List<PokemonsCompanion> list = List.empty(growable: true);

    for (Pokemon pokemon in pokemons) {
      list.add(mapToCompanion(pokemon));
    }

    return list;
  }
}
