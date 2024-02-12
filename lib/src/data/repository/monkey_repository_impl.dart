import 'package:monkey_mon/src/core/utils/internet_connection_checker.dart';
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

  @override
  Future<List<MonkeyDto>> build() async {
    return getAllMonkeys();
  }

  // TODO Check internet connection and connect rest databases

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
    final List<Monkey> monkeys = await database.monkeysDao.getAllMonkeys();

    if (monkeys.isEmpty && await internetConnectionChecker.isConnected()) {
      // TODO Fetch remote api
      throw UnimplementedError();
    }

    return MonkeyMapper.mapToDtoList(monkeys);
  }

  @override
  Future<MonkeyDto?> getMonkey(int id) async {
    final Monkey? monkey = await database.monkeysDao.getMonkey(id);

    if (monkey == null) {
      if (await internetConnectionChecker.isConnected()) {
        throw UnimplementedError();
      } else {
        return null;
      }
    } else {
      return MonkeyMapper.mapToDto(monkey);
    }
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
