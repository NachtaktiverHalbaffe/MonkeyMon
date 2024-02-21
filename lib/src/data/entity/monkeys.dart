// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

import 'species.dart';

class Monkeys extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get knownFrom => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get strength => text().nullable()();
  TextColumn get weaknesses => text().nullable()();
  TextColumn get image => text().nullable()();
  IntColumn get attack =>
      integer().check(attack.isBiggerOrEqual(const Constant(0))).nullable()();
  IntColumn get defense =>
      integer().check(defense.isBiggerOrEqual(const Constant(0))).nullable()();
  IntColumn get specialAttack => integer()
      .check(specialAttack.isBiggerOrEqual(const Constant(0)))
      .nullable()();
  IntColumn get specialDefense => integer()
      .check(specialDefense.isBiggerOrEqual(const Constant(0)))
      .nullable()();
  IntColumn get speed =>
      integer().check(speed.isBiggerOrEqual(const Constant(0))).nullable()();
  IntColumn get healthPoints => integer()
      .check(healthPoints.isBiggerOrEqual(const Constant(0)))
      .nullable()();
  TextColumn get species => text().nullable().references(Species, #name)();

  @override
  Set<Column> get primaryKey => {id};
}
