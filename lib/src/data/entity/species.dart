import 'package:drift/drift.dart';

import '../datasources/listconverter.dart';
import '../datasources/mapconverter.dart';

@DataClassName("SingleSpecies")
class Species extends Table {
  TextColumn get name => text()();
  TextColumn get taxonomy =>
      text().map(MapTypeConverter<String, String>()).nullable()();
  TextColumn get locations =>
      text().map(ListTypeConverter<String>()).nullable()();
  TextColumn get characteristics =>
      text().map(MapTypeConverter<String, String>()).nullable()();

  @override
  Set<Column> get primaryKey => {name};
}
