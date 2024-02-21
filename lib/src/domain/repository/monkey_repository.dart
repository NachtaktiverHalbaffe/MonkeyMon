import 'dart:io';

import '../model/monkey_dto.dart';
import '../model/species_dto.dart';

abstract class MonkeyRepository {
  Future<MonkeyDto?> createMonkey(
      {required MonkeyDto monkeyDto, SpeciesDto? speciesDto, File? image});

  Future<List<MonkeyDto>> getAllMonkeys();

  Future<MonkeyDto?> getMonkey(int id);

  Future<MonkeyDto?> updateMonkey({required MonkeyDto monkeyDto, File? image});

  Future<bool> deleteMonkey(int id);
}
