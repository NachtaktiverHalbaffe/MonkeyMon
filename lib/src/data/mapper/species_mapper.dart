import 'package:drift/drift.dart';

import '../../domain/model/species_dto.dart';
import '../datasources/app_database.dart';

class SpeciesMapper {
  static SpeciesDto mapToDto(SingleSpecies species) {
    return SpeciesDto(
      name: species.name,
      taxonomy: species.taxonomy,
      locations: species.locations,
      characteristics: species.characteristics,
    );
  }

  static SpeciesCompanion mapFromDto(SpeciesDto species) {
    return SpeciesCompanion(
      name: Value<String>(species.name),
      taxonomy: Value<Map<String, String>?>(species.taxonomy),
      locations: Value<List<String>?>(species.locations),
      characteristics: Value<Map<String, String>?>(species.characteristics),
    );
  }

  static List<SpeciesDto> mapToDtoList(List<SingleSpecies> speciesList) {
    List<SpeciesDto> list = List.empty(growable: true);

    for (int i = 0; i < speciesList.length; i++) {
      list.add(mapToDto(speciesList[i]));
    }

    return list;
  }

  static List<SpeciesCompanion> mapFromDtoList(
      List<SpeciesDto> speciesDtoList) {
    List<SpeciesCompanion> list = List.empty(growable: true);

    for (int i = 0; i < speciesDtoList.length; i++) {
      list.add(mapFromDto(speciesDtoList[i]));
    }

    return list;
  }

  static SpeciesCompanion mapToCompanion(SingleSpecies species) {
    return SpeciesCompanion(
      name: Value<String>(species.name),
      taxonomy: Value<Map<String, String>?>(species.taxonomy),
      locations: Value<List<String>?>(species.locations),
      characteristics: Value<Map<String, String>?>(species.characteristics),
    );
  }

  static List<SpeciesCompanion> mapToCompanionList(
      List<SingleSpecies> species) {
    List<SpeciesCompanion> companions = List.empty(growable: true);

    for (int i = 0; i < species.length; i++) {
      companions.add(mapToCompanion(species[i]));
    }

    return companions;
  }
}
