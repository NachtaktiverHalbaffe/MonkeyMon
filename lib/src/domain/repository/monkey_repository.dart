import '../model/monkey_dto.dart';
import '../model/species_dto.dart';

abstract class MonkeyRepository {
  Future<MonkeyDto?> createMonkey(
      {required MonkeyDto monkeyDto, SpeciesDto? speciesDto});

  Future<List<MonkeyDto>> getAllMonkeys();

  Future<MonkeyDto?> getMonkey(int id);

  Future<MonkeyDto?> updateMonkey(
      {required MonkeyDto monkeyDto, SpeciesDto? speciesDto});

  Future<bool> deleteMonkey(int id);
}
