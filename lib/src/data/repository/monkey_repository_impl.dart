import 'dart:io';

import 'package:monkey_mon/src/core/utils/internet_connection_checker.dart';
import 'package:monkey_mon/src/core/utils/logger.dart';
import 'package:monkey_mon/src/data/datasources/monkeys_remote_datasource.dart';
import 'package:monkey_mon/src/data/mapper/species_mapper.dart';
import 'package:monkey_mon/src/domain/repository/monkey_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import "package:monkey_mon/src/data/datasources/app_database.dart";

import '../../domain/model/monkey_dto.dart';
import '../../domain/model/species_dto.dart';
import '../mapper/monkey_mapper.dart';

part "monkey_repository_impl.g.dart";

@riverpod
class MonkeyRepositoryImpl extends _$MonkeyRepositoryImpl
    implements MonkeyRepository {
  late final AppDatabase database;
  late final InternetConnectionChecker internetConnectionChecker;
  late final MonkeysRemoteDatasource remoteDatasource;

  @override
  Future<List<MonkeyDto>> build({String? baseUrl}) async {
    database = ref.read(databaseProvider);
    internetConnectionChecker =
        ref.read(internetConnectionCheckerProvider.notifier);
    remoteDatasource = ref.read(monkeyRemoteDatasourceProvider(baseUrl ?? ""));

    return getAllMonkeys();
  }

  @override
  Future<MonkeyDto?> createMonkey(
      {required MonkeyDto monkeyDto,
      SpeciesDto? speciesDto,
      File? image}) async {
    MonkeyDto? createdMonkeyDto;
    final MonkeysCompanion monkeysCompanion =
        MonkeyMapper.mapFromDto(monkeyDto);

    if (await internetConnectionChecker.isConnected()) {
      // Also create in REST API
      final (createdMonkey, createdSpecies) =
          await remoteDatasource.createMonkey(monkeysCompanion, image: image);
      if (createdMonkey != null) {
        if (createdSpecies != null) {
          createdMonkeyDto = MonkeyMapper.mapToDto(createdMonkey,
              species: SpeciesMapper.mapToDto(createdSpecies));
          // Caching
          await database.createMonkeyWithSpeciesInformation(
              MonkeyMapper.mapToCompanion(createdMonkey),
              SpeciesMapper.mapToCompanion(createdSpecies));
        } else {
          createdMonkeyDto = MonkeyMapper.mapToDto(createdMonkey);
          // Caching
          await database.monkeysDao.createMonkey(
            MonkeyMapper.mapToCompanion(createdMonkey),
          );
        }
      }
    } else {
      // Offline creation
      if (speciesDto != null) {
        final createdMonkey = await database.createMonkeyWithSpeciesInformation(
            monkeysCompanion, SpeciesMapper.mapFromDto(speciesDto));
        if (createdMonkey != null) {
          createdMonkeyDto =
              MonkeyMapper.mapToDto(createdMonkey, species: speciesDto);
        }
      } else {
        final createdMonkey =
            await database.monkeysDao.createMonkey(monkeysCompanion);
        if (createdMonkey != null) {
          createdMonkeyDto = MonkeyMapper.mapToDto(createdMonkey);
        }
      }
    }

    return createdMonkeyDto;
  }

  @override
  Future<bool> deleteMonkey(int id) async {
    final int opResult = await database.monkeysDao.deleteMonkey(id);
    return opResult >= 1 ? true : false;
  }

  @override
  Future<List<MonkeyDto>> getAllMonkeys() async {
    List<Monkey> monkeys = List.empty(growable: true);
    if (await internetConnectionChecker.isConnected()) {
      List<SingleSpecies> species = List.empty(growable: true);
      try {
        (monkeys, species) = await remoteDatasource.getAllMonkeys();
      } on Exception catch (e) {
        getLogger().w(e);
        return List.empty();
      }

      List<MonkeysCompanion> monkeyCompanions =
          MonkeyMapper.mapToCompanionList(monkeys);
      List<SpeciesCompanion> speciesCompanions =
          SpeciesMapper.mapToCompanionList(species);

      // Caching
      for (int i = 0; i < monkeyCompanions.length; i++) {
        try {
          await database.createMonkeyWithSpeciesInformation(
              monkeyCompanions[i], speciesCompanions[i]);
        } catch (e) {
          getLogger().d("Entry already present, refreshing caching needed");
          await deleteMonkey(monkeyCompanions[i].id.value);
          await database.speciesDao
              .deleteSpecies(speciesCompanions[i].name.value);
          await database.createMonkeyWithSpeciesInformation(
              monkeyCompanions[i], speciesCompanions[i]);
        }
      }

      return MonkeyMapper.mapToDtoList(monkeys,
          species: SpeciesMapper.mapToDtoList(species));
    } else {
      monkeys.addAll(await database.monkeysDao.getAllMonkeys());
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
      {required MonkeyDto monkeyDto, File? image}) async {
    MonkeyDto? updatedMonkeyDto;
    print(monkeyDto);
    final MonkeysCompanion monkeysCompanion =
        MonkeyMapper.mapFromDto(monkeyDto);

    if (await internetConnectionChecker.isConnected()) {
      getLogger().d("Updating monkey in REST API backend");
      // Also create in REST API
      final (updatedMonkey, updatedSpecies) =
          await remoteDatasource.updateMonkey(monkeysCompanion, image: image);
      if (updatedMonkey != null) {
        if (updatedSpecies != null) {
          updatedMonkeyDto = MonkeyMapper.mapToDto(updatedMonkey,
              species: SpeciesMapper.mapToDto(updatedSpecies));
          // Caching
          await database.updateMonkeyWithSpeciesInformation(
              MonkeyMapper.mapToCompanion(updatedMonkey),
              SpeciesMapper.mapToCompanion(updatedSpecies));
        } else {
          updatedMonkeyDto = MonkeyMapper.mapToDto(updatedMonkey);
          // Caching
          await database.monkeysDao.updateMonkey(
            MonkeyMapper.mapToCompanion(updatedMonkey),
          );
        }
      }
    } else {
      Monkey? updatedMonkey =
          await database.monkeysDao.updateMonkey(monkeysCompanion);
      if (updatedMonkey != null) {
        updatedMonkeyDto = MonkeyMapper.mapToDto(updatedMonkey);
      }
    }

    return updatedMonkeyDto;
  }
}
