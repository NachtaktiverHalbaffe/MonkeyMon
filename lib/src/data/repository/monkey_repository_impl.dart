import 'package:monkey_mon/src/core/utils/internet_connection_checker.dart';
import 'package:monkey_mon/src/data/datasources/monkeys_remote_datasource.dart';
import 'package:monkey_mon/src/data/mapper/species_mapper.dart';
import 'package:monkey_mon/src/domain/repository/monkey_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import "package:monkey_mon/src/data/datasources/app_database.dart" as db;

import '../../domain/model/monkey_dto.dart';
import '../../domain/model/species_dto.dart';
import '../datasources/app_database.dart';
import '../mapper/monkey_mapper.dart';

part "monkey_repository_impl.g.dart";

@riverpod
class MonkeyRepositoryImpl extends _$MonkeyRepositoryImpl
    implements MonkeyRepository {
  late final AppDatabase database = ref.read(db.databaseProvider);
  late final InternetConnectionChecker internetConnectionChecker =
      ref.read(internetConnectionCheckerProvider.notifier);
  late final MonkeysRemoteDatasource remoteDatasource =
      ref.read(monkeyRemoteDatasourceProvider);

  @override
  Future<List<MonkeyDto>> build() async {
    return getAllMonkeys();
  }

  @override
  Future<MonkeyDto?> createMonkey(
      {required MonkeyDto monkeyDto, SpeciesDto? speciesDto}) async {
    final MonkeysCompanion monkeysCompanion =
        MonkeyMapper.mapFromDto(monkeyDto);

    if (speciesDto != null) {
      final createdMonkey = await database.createMonkeyWithSpeciesInformation(
          monkeysCompanion, SpeciesMapper.mapFromDto(speciesDto));
      if (createdMonkey != null) {
        return MonkeyMapper.mapToDto(createdMonkey, species: speciesDto);
      }
    } else {
      final createdMonkey =
          await database.monkeysDao.createMonkey(monkeysCompanion);
      if (createdMonkey != null) {
        return MonkeyMapper.mapToDto(createdMonkey);
      }
    }

    return null;
  }

  @override
  Future<bool> deleteMonkey(int id) async {
    final int opResult = await database.monkeysDao.deleteMonkey(id);
    return opResult >= 1 ? true : false;
  }

  @override
  Future<List<MonkeyDto>> getAllMonkeys() async {
    List<Monkey> monkeys = await database.monkeysDao.getAllMonkeys();

    if (monkeys.isEmpty && await internetConnectionChecker.isConnected()) {
      List<SingleSpecies> species = List.empty(growable: true);
      try {
        (monkeys, species) = await remoteDatasource.getAllMonkeys();
      } on Exception {
        return List.empty();
      }

      List<MonkeysCompanion> monkeyCompanions =
          MonkeyMapper.mapToCompanionList(monkeys);
      List<SpeciesCompanion> speciesCompanions =
          SpeciesMapper.mapToCompanionList(species);

      // Caching
      for (int i = 0; i < monkeyCompanions.length; i++) {
        await database.createMonkeyWithSpeciesInformation(
            monkeyCompanions[i], speciesCompanions[i]);
      }

      return MonkeyMapper.mapToDtoList(monkeys,
          species: SpeciesMapper.mapToDtoList(species));
    }

    return MonkeyMapper.mapToDtoList(monkeys);
  }

  @override
  Future<MonkeyDto?> getMonkey(int id) async {
    Monkey? monkey = await database.monkeysDao.getMonkey(id);

    if (monkey == null) {
      if (await internetConnectionChecker.isConnected()) {
        SingleSpecies? species;

        try {
          (monkey, species) = await remoteDatasource.getMonkey(id);
        } on Exception {
          return null;
        }

        if (monkey != null && species != null) {
          await database.createMonkeyWithSpeciesInformation(
              MonkeyMapper.mapToCompanion(monkey),
              SpeciesMapper.mapToCompanion(species));
        } else {
          return null;
        }

        return MonkeyMapper.mapToDto(monkey,
            species: SpeciesMapper.mapToDto(species));
      } else {
        // No result and no internet connection
        return null;
      }
    }
    return MonkeyMapper.mapToDto(monkey);
  }

  @override
  Future<MonkeyDto?> updateMonkey(
      {required MonkeyDto monkeyDto, SpeciesDto? speciesDto}) async {
    final MonkeysCompanion monkeysCompanion =
        MonkeyMapper.mapFromDto(monkeyDto);

    if (speciesDto != null) {
      Monkey? updatedMonkey = await database.updateMonkeyWithSpeciesInformation(
          monkeysCompanion, SpeciesMapper.mapFromDto(speciesDto));
      if (updatedMonkey != null) {
        return MonkeyMapper.mapToDto(updatedMonkey, species: speciesDto);
      }
    } else {
      Monkey? updatedMonkey =
          await database.monkeysDao.updateMonkey(monkeysCompanion);
      if (updatedMonkey != null) {
        return MonkeyMapper.mapToDto(updatedMonkey);
      }
    }

    return null;
  }
}
