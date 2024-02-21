import 'package:drift/drift.dart';
import '../entity/pokemon.dart';
import 'app_database.dart';

part "pokemon_dao.g.dart";

@DriftAccessor(tables: [Pokemons])
class PokemonsDao extends DatabaseAccessor<AppDatabase>
    with _$PokemonsDaoMixin {
  PokemonsDao(super.db);

  Future<Pokemon?> createPokemon(PokemonsCompanion pokemon) async {
    return await into(pokemons)
        .insertReturningOrNull(pokemon, mode: InsertMode.insertOrIgnore);
  }

  Future<Pokemon?> getPokemon(int id) async {
    return await (select(pokemons)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<Pokemon?> getPokemonByName(String name) async {
    return await (select(pokemons)..where((tbl) => tbl.name.equals(name)))
        .getSingleOrNull();
  }

  Future<Pokemon?> getPokemonByRowNr(int index) async {
    return await (select(pokemons)..limit(1, offset: index)).getSingleOrNull();
  }

  Future<Pokemon?> getPokemonByMaxStat(
      {int? hp,
      int? attack,
      int? defense,
      int? specialAttack,
      int? specialDefense,
      int? speed}) async {
    var filteredPokemon = select(pokemons);

    if (hp != null) {
      filteredPokemon = filteredPokemon
        ..where((tbl) => tbl.hp.isSmallerOrEqualValue(hp));
    }
    if (attack != null) {
      filteredPokemon = filteredPokemon
        ..where((tbl) => tbl.attack.isSmallerOrEqualValue(attack));
    }
    if (defense != null) {
      filteredPokemon = filteredPokemon
        ..where((tbl) => tbl.defense.isSmallerOrEqualValue(defense));
    }
    if (specialDefense != null) {
      filteredPokemon = filteredPokemon
        ..where((tbl) => tbl.hp.isSmallerOrEqualValue(specialDefense));
    }
    if (specialAttack != null) {
      filteredPokemon = filteredPokemon
        ..where(
            (tbl) => tbl.specialAttack.isSmallerOrEqualValue(specialAttack));
    }
    if (speed != null) {
      filteredPokemon = filteredPokemon
        ..where((tbl) => tbl.speed.isSmallerOrEqualValue(speed));
    }

    return filteredPokemon.getSingleOrNull();
  }

  Future<List<Pokemon>> getAllPokemon() async {
    return await select(pokemons).get();
  }

  Future<Pokemon?> updatePokemon(PokemonsCompanion pokemon) async {
    final List<Pokemon> updatedPokemons = await (update(pokemons)
          ..where((tbl) => tbl.id.equals(pokemon.id.value)))
        .writeReturning(pokemon);

    if (updatedPokemons.isEmpty) {
      return null;
    } else {
      return updatedPokemons.first;
    }
  }

  Future<int> deletePokemon(int id) async {
    return await (delete(pokemons)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deletePokemonByName(String name) async {
    return await (delete(pokemons)..where((tbl) => tbl.name.equals(name))).go();
  }

  Future<int> getNrOfPokemon() async {
    return await pokemons.count().getSingle();
  }
}
