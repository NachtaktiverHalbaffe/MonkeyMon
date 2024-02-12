import 'package:drift/drift.dart';

import '../entity/species.dart';
import 'app_database.dart';

part "species_dao.g.dart";

@DriftAccessor(tables: [Species])
class SpeciesDao extends DatabaseAccessor<AppDatabase> with _$SpeciesDaoMixin {
  SpeciesDao(super.db);

  Future<void> createSpecies(SpeciesCompanion singleSpecies) async {
    await into(species).insert(singleSpecies);
  }

  Future<List<SingleSpecies>> getAllSpecies() async {
    return await select(species).get();
  }

  Future<SingleSpecies> getSpecies(String name) async {
    return await (select(species)..where((tbl) => tbl.name.equals(name)))
        .getSingle();
  }

  Future<int> updateSpecies(SpeciesCompanion updateData) async {
    return await (update(species)
          ..where((tbl) => tbl.name.equals(updateData.name.value)))
        .write(updateData);
  }

  Future<int> deleteSpecies(String name) async {
    return await (delete(species)..where((tbl) => tbl.name.equals(name))).go();
  }
}
