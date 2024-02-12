import 'package:flutter_test/flutter_test.dart';
import 'package:monkey_mon/src/data/datasources/app_database.dart';
import 'package:monkey_mon/src/data/mapper/species_mapper.dart';
import 'package:monkey_mon/src/domain/model/species_dto.dart';

import '../test_data.dart';

void main() {
  group('mapToDto', () {
    test('should map to dto ', () {
      final SingleSpecies testData = generateSingleSpecies();
      final SpeciesDto expectedResult = generateSpeciesDto();
      expect(SpeciesMapper.mapToDto(testData), expectedResult);
    });
  });

  group("mapFromDto", () {
    test("Should map to companion ", () {
      final SpeciesDto testData = generateSpeciesDto();
      final SpeciesCompanion expectedResult = generateSpeciesCompanion();
      expect(SpeciesMapper.mapFromDto(testData), expectedResult);
    });
  });

  group("mapToDtoList", () {
    test("should map to list of speciesdto's ", () {
      final SingleSpecies testElement = generateSingleSpecies();
      final List<SingleSpecies> testData = [
        testElement,
        testElement,
        testElement
      ];
      final SpeciesDto expectedElement = generateSpeciesDto();
      final List<SpeciesDto> expectedResult = [
        expectedElement,
        expectedElement,
        expectedElement
      ];

      expect(SpeciesMapper.mapToDtoList(testData), expectedResult);
    });
  });
  group("mapFromDtoList", () {
    test("should map to list of speciescompanion ", () {
      final SpeciesDto testElement = generateSpeciesDto();
      final List<SpeciesDto> testData = [testElement, testElement, testElement];
      final SpeciesCompanion expectedElement = generateSpeciesCompanion();
      final List<SpeciesCompanion> expectedResult = [
        expectedElement,
        expectedElement,
        expectedElement
      ];

      expect(SpeciesMapper.mapFromDtoList(testData), expectedResult);
    });
  });
}
