import 'package:cancellation_token/cancellation_token.dart';
import 'package:monkey_mon/src/data/datasources/app_database.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';
import 'package:monkey_mon/src/exceptions/network_exception.dart';
import 'package:pokedex/pokedex.dart' as pokedex_api;
import 'package:riverpod_annotation/riverpod_annotation.dart';

final pokemonRemoteDatasourceProvider = Provider<PokemonRemoteDatasource>(
  (ref) => PokemonRemoteDatasource(),
);

class PokemonRemoteDatasource {
  final pokedex_api.Pokedex pokedex = pokedex_api.Pokedex();

  Future<Pokemon?> getPokemon({int? id, String? name}) async {
    Pokemon pokemon;
    if (id == null && name == null) {
      throw ArgumentError("either id or name has to be given");
    }
    try {
      if (id != null) {
        pokemon = await _parsePokemon(await pokedex.pokemon.get(id: id));
      } else {
        pokemon = await _parsePokemon(await pokedex.pokemon.get(name: name));
      }

      return pokemon;
    } on Exception {
      throw NetworkExcpetion("Couldnt get results from Pokeapi",
          type: NetworkExceptionType.connectionError);
    }
  }

  Future<List<Pokemon>> getAllPokemon({int? limit, int? offset}) async {
    List<Pokemon> pokemons = List.empty(growable: true);
    final List<pokedex_api.NamedAPIResource> remotePokemons;
    try {
      remotePokemons = (await pokedex.pokemon
              .getPage(limit: limit ?? 20000, offset: offset ?? 0))
          .results;
    } on Exception {
      throw NetworkExcpetion("Couldnt get results from Pokeapi",
          type: NetworkExceptionType.connectionError);
    }

    for (int i = 0; i < remotePokemons.length; i++) {
      try {
        final pokemon = await _parsePokemon(
            await pokedex.pokemon.getByUrl(remotePokemons[i].url));
        pokemons.add(pokemon);
      } on Exception {
        throw NetworkExcpetion("Couldnt get results from Pokeapi",
            type: NetworkExceptionType.connectionError);
      }
    }

    return pokemons;
  }

  Future<int> getNrOfTotalPokemon() async {
    try {
      return (await pokedex.pokemon.getPage(limit: 20000)).count;
    } on Exception {
      throw NetworkExcpetion("Couldnt get results from Pokeapi",
          type: NetworkExceptionType.connectionError);
    }
  }

  Stream<Pokemon> streamAllPokemon({
    int? limit,
    int? offset,
    CancellationToken? cancellationToken,
  }) async* {
    final List<pokedex_api.NamedAPIResource> remotePokemons;
    try {
      remotePokemons = (await pokedex.pokemon
              .getPage(limit: limit ?? 20000, offset: offset ?? 0))
          .results;
    } on Exception {
      throw NetworkExcpetion("Couldnt get results from Pokeapi",
          type: NetworkExceptionType.connectionError);
    }

    for (int i = 0; i < remotePokemons.length; i++) {
      if (cancellationToken != null) {
        if (cancellationToken.isCancelled) {
          return;
        }
      }
      try {
        final Pokemon pokemon = await _parsePokemon(
            await pokedex.pokemon.getByUrl(remotePokemons[i].url));
        yield pokemon;
      } on Exception {
        throw NetworkExcpetion("Couldnt get results from Pokeapi",
            type: NetworkExceptionType.connectionError);
      }
    }
  }

  Future<Pokemon> _parsePokemon(pokedex_api.Pokemon remotePokemon) async {
    int attack = 0;
    int defense = 0;
    int specialAttack = 0;
    int specialDefense = 0;
    int speed = 0;
    int hp = 0;
    String description = "";
    String name = "";
    List<String> types = List.empty(growable: true);

    for (int i = 0; i < remotePokemon.stats.length; i++) {
      switch (remotePokemon.stats[i].stat.name) {
        case "hp":
          hp = remotePokemon.stats[i].baseStat;
          break;
        case "attack":
          attack = remotePokemon.stats[i].baseStat;
          break;
        case "defense":
          defense = remotePokemon.stats[i].baseStat;
          break;
        case "special-attack":
          specialAttack = remotePokemon.stats[i].baseStat;
          break;
        case "special-defense":
          specialDefense = remotePokemon.stats[i].baseStat;
          break;
        case "speed":
          speed = remotePokemon.stats[i].baseStat;
          break;
        default:
      }
    }

    for (int i = 0; i < remotePokemon.types.length; i++) {
      types.add(remotePokemon.types[i].type.name);
    }

    final Future<pokedex_api.PokemonSpecies> pokemonSpecies;
    try {
      pokemonSpecies = pokedex_api.Pokedex()
          .pokemonSpecies
          .getByUrl(remotePokemon.species.url);
    } on Exception {
      throw NetworkExcpetion("Couldnt get results from Pokeapi",
          type: NetworkExceptionType.connectionError);
    }

    final List<pokedex_api.FlavorText> pokemonDescriptions =
        await pokemonSpecies.then((value) => value.flavorTextEntries);
    for (int i = 0; i < pokemonDescriptions.length; i++) {
      if (pokemonDescriptions[i].language.name == "de") {
        description = pokemonDescriptions[i].flavorText;
        description = description.replaceAll("\n", " ");
        break;
      }
    }

    final List<pokedex_api.Name> pokemonNames =
        await pokemonSpecies.then((value) => value.names);
    for (int i = 0; i < pokemonNames.length; i++) {
      if (pokemonNames[i].language.name == "de") {
        name = pokemonNames[i].name;
        break;
      }
    }

    return Pokemon(
        id: remotePokemon.id,
        name: name,
        description: description,
        attack: attack,
        defense: defense,
        specialAttack: specialAttack,
        specialDefense: specialDefense,
        speed: speed,
        hp: hp,
        types: types,
        sprites: PokemonSprites(
            frontDefault: remotePokemon.sprites.frontDefault,
            frontShiny: remotePokemon.sprites.frontShiny,
            frontFemale: remotePokemon.sprites.frontFemale,
            frontShinyFemale: remotePokemon.sprites.frontShinyFemale,
            backDefault: remotePokemon.sprites.backDefault,
            backShiny: remotePokemon.sprites.backShiny,
            backFemale: remotePokemon.sprites.backFemale,
            backShinyFemale: remotePokemon.sprites.backShinyFemale));
  }
}
