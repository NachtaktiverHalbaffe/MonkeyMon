import 'package:flutter_test/flutter_test.dart';
import 'package:monkey_mon/src/data/datasources/app_database.dart';
import 'package:monkey_mon/src/data/mapper/monkey_mapper.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:monkey_mon/src/domain/model/species_dto.dart';

import '../test_data.dart';

void main() {
  group('mapToDto', () {
    test('should map to dto without species data', () {
      final Monkey testData = generateMonkey();
      final MonkeyDto expectedResult = generateMonkeyDto();
      expect(MonkeyMapper.mapToDto(testData), expectedResult);
    });
    test("should map to dto with species data", () {
      final Monkey testDataMonkey = generateMonkey();
      final SpeciesDto speciesDto = generateSpeciesDto();
      final MonkeyDto expectedResult = generateMonkeyDtoWithSpeciesData();
      expect(MonkeyMapper.mapToDto(testDataMonkey, species: speciesDto),
          expectedResult);
    });
  });

  group("mapFromDto", () {
    test("Should map to companion without speciesdata", () {
      final MonkeyDto testData = generateMonkeyDto();
      final MonkeysCompanion expectedResult = generateMonkeyCompanion();
      expect(MonkeyMapper.mapFromDto(testData), expectedResult);
    });

    test("Should map to companion with species data", () {
      final MonkeyDto testDataMonkey = generateMonkeyDtoWithSpeciesData();
      final MonkeysCompanion expectedResult =
          generateMonkeyCompanionWithSpeciesData();
      expect(MonkeyMapper.mapFromDto(testDataMonkey), expectedResult);
    });
  });

  group("mapToDtoList", () {
    test("should map to list of monkeydto's without speciesdata", () {
      final Monkey testElement = generateMonkey();
      final List<Monkey> testData = [testElement, testElement, testElement];
      final MonkeyDto expectedElement = generateMonkeyDto();
      final List<MonkeyDto> expectedResult = [
        expectedElement,
        expectedElement,
        expectedElement
      ];

      expect(MonkeyMapper.mapToDtoList(testData), expectedResult);
    });

    test("""should that mismatched length of lists throws an exception""", () {
      final Monkey testElementMonkey = generateMonkey();
      final List<Monkey> testDataMonkey = [
        testElementMonkey,
        testElementMonkey,
        testElementMonkey
      ];
      final SpeciesDto testElementSpecies = generateSpeciesDto();
      final List<SpeciesDto?>? testDataSpecies = [
        testElementSpecies,
        testElementSpecies
      ];
      expect(
          () => MonkeyMapper.mapToDtoList(testDataMonkey,
              species: testDataSpecies),
          throwsA(isArgumentError));
    });

    test(
        """should map to list of monkeydtos with speciesdata where all elements have 
        speciesdata""", () {
      final Monkey testElementMonkey = generateMonkey();
      final List<Monkey> testDataMonkey = [
        testElementMonkey,
        testElementMonkey,
        testElementMonkey
      ];
      final SpeciesDto testElementSpecies = generateSpeciesDto();
      final List<SpeciesDto?>? testDataSpecies = [
        testElementSpecies,
        testElementSpecies,
        testElementSpecies
      ];

      final MonkeyDto expectedElement = generateMonkeyDtoWithSpeciesData();
      final List<MonkeyDto> expectedResult = [
        expectedElement,
        expectedElement,
        expectedElement
      ];

      expect(
          MonkeyMapper.mapToDtoList(testDataMonkey, species: testDataSpecies),
          expectedResult);
    });

    test("""should map to list of monkeydtos with speciesdata where 
        some elements have data and some are null""", () {
      final Monkey testElementMonkey = generateMonkey();
      final List<Monkey> testDataMonkey = [
        testElementMonkey,
        testElementMonkey,
        testElementMonkey
      ];
      final SpeciesDto testElementSpecies = generateSpeciesDto();
      final List<SpeciesDto?>? testDataSpecies = [
        testElementSpecies,
        null,
        testElementSpecies
      ];
      final MonkeyDto expectedElement = generateMonkeyDtoWithSpeciesData();
      final List<MonkeyDto> expectedResult = [
        expectedElement,
        generateMonkeyDto(),
        expectedElement
      ];

      expect(
          MonkeyMapper.mapToDtoList(testDataMonkey, species: testDataSpecies),
          expectedResult);
    });
  });
  group("mapFromDtoList", () {
    test("should map to list of monkeyscompanion without speciesdata", () {
      final MonkeyDto testElement = generateMonkeyDto();
      final List<MonkeyDto> testData = [testElement, testElement, testElement];
      final MonkeysCompanion expectedElement = generateMonkeyCompanion();
      final List<MonkeysCompanion> expectedResult = [
        expectedElement,
        expectedElement,
        expectedElement
      ];

      expect(MonkeyMapper.mapFromDtoList(testData), expectedResult);
    });

    test("""should map to list of monkeycompanion with speciesdata""", () {
      final MonkeyDto testElement = generateMonkeyDtoWithSpeciesData();
      final List<MonkeyDto> testData = [testElement, testElement, testElement];

      final MonkeysCompanion expectedElement =
          generateMonkeyCompanionWithSpeciesData();
      final List<MonkeysCompanion> expectedResult = [
        expectedElement,
        expectedElement,
        expectedElement
      ];

      expect(MonkeyMapper.mapFromDtoList(testData), expectedResult);
    });
  });

  test("linkMonkeyWithSpecies", () {
    final MonkeyDto testDataMonkey = generateMonkeyDto();
    final SpeciesDto testDataSpecies = generateSpeciesDto();
    final MonkeyDto expectedResult = generateMonkeyDtoWithSpeciesData();

    expect(MonkeyMapper.linkMonkeyWithSpecies(testDataMonkey, testDataSpecies),
        expectedResult);
  });
}
