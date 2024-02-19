// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';
import '../datasources/listconverter.dart';
import '../datasources/pokemon_sprite_converter.dart';

class Pokemons extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get attack =>
      integer().check(attack.isBiggerOrEqual(const Constant(0)))();
  IntColumn get defense =>
      integer().check(defense.isBiggerOrEqual(const Constant(0)))();
  IntColumn get specialAttack =>
      integer().check(specialAttack.isBiggerOrEqual(const Constant(0)))();
  IntColumn get specialDefense =>
      integer().check(specialDefense.isBiggerOrEqual(const Constant(0)))();
  IntColumn get speed =>
      integer().check(speed.isBiggerOrEqual(const Constant(0)))();
  IntColumn get hp => integer().check(hp.isBiggerOrEqual(const Constant(0)))();
  TextColumn get types => text().map(ListTypeConverter<String>())();
  TextColumn get sprites => text().map(PokemonSpriteConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
