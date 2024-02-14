import 'package:drift/drift.dart';
import 'package:monkey_mon/src/data/datasources/app_database.dart';
import '../entity/pokemon.dart';

part "pokemon_dao.g.dart";

@DriftAccessor(tables: [Pokemons])
class PokemonsDao extends DatabaseAccessor<AppDatabase>
    with _$PokemonsDaoMixin {
  PokemonsDao(super.db);

  Future<Pokemon?> createPokemon(PokemonsCompanion pokemon) {
    return into(pokemons)
        .insertReturningOrNull(pokemon, mode: InsertMode.insertOrIgnore);
  }

  Future<Pokemon?> getPokemon(int id) async {
    return await (select(pokemons)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
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

  Future<int> deleteMonkey(int id) async {
    return await (delete(pokemons)..where((tbl) => tbl.id.equals(id))).go();
  }
}
