import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:monkey_mon/src/data/datasources/monkeys_dao.dart';
import 'package:monkey_mon/src/data/datasources/species_dao.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// It is important to import entities with this notation style, otherwise build_runner will fail
import '../entity/monkeys.dart';
import '../entity/species.dart';
import 'listconverter.dart';
import 'mapconverter.dart';

part "app_database.g.dart";

final databaseProvider = Provider<AppDatabase>(
  (ref) => AppDatabase(),
);

@DriftDatabase(tables: [Monkeys, Species], daos: [MonkeysDao, SpeciesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? testingEngine})
      : super(testingEngine ?? _openConnection());

  @override
  int get schemaVersion => 1;

  Future<Monkey?> createMonkeyWithSpeciesInformation(
      MonkeysCompanion monkeyData, SpeciesCompanion speciesData) async {
    MonkeysCompanion linkedData = MonkeysCompanion(
        id: monkeyData.id,
        name: monkeyData.name,
        knownFrom: monkeyData.knownFrom,
        description: monkeyData.description,
        strength: monkeyData.description,
        weaknesses: monkeyData.weaknesses,
        attack: monkeyData.attack,
        defense: monkeyData.defense,
        specialAttack: monkeyData.specialAttack,
        specialDefense: monkeyData.specialDefense,
        speed: monkeyData.speed,
        healthPoints: monkeyData.healthPoints,
        species: speciesData.name);

    Monkey? monkey;
    await transaction(() async {
      monkey = await monkeysDao.createMonkey(linkedData);
      if (monkey != null) {
        await speciesDao.createSpecies(speciesData);
      }
    });

    return monkey;
  }

  Future<Monkey?> updateMonkeyWithSpeciesInformation(
      MonkeysCompanion monkeyData, SpeciesCompanion speciesData) async {
    MonkeysCompanion linkedData =
        monkeyData.copyWith(species: speciesData.name);

    Monkey? monkey;
    await transaction(() async {
      monkey = await monkeysDao.updateMonkey(linkedData);
      if (monkey != null) {
        await speciesDao.updateSpecies(speciesData);
      }
    });

    return monkey;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(
      file,
      logStatements: kDebugMode,
    );
  });
}
