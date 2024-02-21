import 'package:drift/drift.dart';
import 'package:monkey_mon/src/domain/model/species_dto.dart';

import '../../domain/model/monkey_dto.dart';
import '../datasources/app_database.dart';

class MonkeyMapper {
  static MonkeyDto mapToDto(Monkey monkey, {SpeciesDto? species}) {
    return MonkeyDto(
        id: monkey.id,
        name: monkey.name,
        knownFrom: monkey.knownFrom,
        description: monkey.description,
        image: monkey.image,
        strength: monkey.strength,
        weaknesses: monkey.weaknesses,
        attack: monkey.attack ?? 0,
        defense: monkey.defense ?? 0,
        specialAttack: monkey.specialAttack ?? 0,
        specialDefense: monkey.specialDefense ?? 0,
        speed: monkey.speed ?? 0,
        hp: monkey.healthPoints ?? 0,
        species: species);
  }

  static MonkeysCompanion mapFromDto(MonkeyDto monkeyDto) {
    if (monkeyDto.species != null) {
      return MonkeysCompanion(
        id: Value<int>(monkeyDto.id),
        name: Value<String>(monkeyDto.name),
        knownFrom: Value<String?>(monkeyDto.knownFrom),
        description: Value<String?>(monkeyDto.description),
        strength: Value<String?>(monkeyDto.strength),
        weaknesses: Value<String?>(monkeyDto.weaknesses),
        attack: Value<int?>(monkeyDto.attack),
        defense: Value<int?>(monkeyDto.defense),
        specialAttack: Value<int?>(monkeyDto.specialAttack),
        specialDefense: Value<int?>(monkeyDto.specialDefense),
        speed: Value<int?>(monkeyDto.speed),
        healthPoints: Value<int?>(monkeyDto.hp),
        species: Value<String?>(monkeyDto.species!.name),
      );
    } else {
      return MonkeysCompanion(
        id: Value<int>(monkeyDto.id),
        name: Value<String>(monkeyDto.name),
        knownFrom: Value<String?>(monkeyDto.knownFrom),
        description: Value<String?>(monkeyDto.description),
        strength: Value<String?>(monkeyDto.strength),
        weaknesses: Value<String?>(monkeyDto.weaknesses),
        attack: Value<int?>(monkeyDto.attack),
        defense: Value<int?>(monkeyDto.defense),
        specialAttack: Value<int?>(monkeyDto.specialAttack),
        specialDefense: Value<int?>(monkeyDto.specialDefense),
        speed: Value<int?>(monkeyDto.speed),
        healthPoints: Value<int?>(monkeyDto.hp),
      );
    }
  }

  static List<MonkeyDto> mapToDtoList(List<Monkey> monkeys,
      {List<SpeciesDto?>? species}) {
    List<MonkeyDto> list = List.empty(growable: true);

    if (species != null) {
      if (species.length != monkeys.length) {
        throw ArgumentError(
            """Monkey and Species dont have same length. Make sure to have a corresponding list of 
            species to the monkey list, where each monkey hast one species at the same indey""");
      }
    }

    for (int i = 0; i < monkeys.length; i++) {
      if (species != null) {
        list.add(mapToDto(monkeys[i], species: species[i]));
      } else {
        list.add(mapToDto(monkeys[i]));
      }
    }

    return list;
  }

  static List<MonkeysCompanion> mapFromDtoList(List<MonkeyDto> monkeys) {
    List<MonkeysCompanion> list = List.empty(growable: true);

    for (int i = 0; i < monkeys.length; i++) {
      list.add(mapFromDto(monkeys[i]));
    }

    return list;
  }

  static MonkeyDto linkMonkeyWithSpecies(
      MonkeyDto monkeyDto, SpeciesDto speciesDto) {
    return monkeyDto.copyWith(species: speciesDto);
  }

  static MonkeysCompanion mapToCompanion(Monkey monkey) {
    return MonkeysCompanion(
        id: Value<int>(monkey.id),
        name: Value<String>(monkey.name),
        knownFrom: Value<String?>(monkey.knownFrom),
        description: Value<String?>(monkey.description),
        strength: Value<String?>(monkey.strength),
        weaknesses: Value<String?>(monkey.weaknesses),
        attack: Value<int?>(monkey.attack),
        defense: Value<int?>(monkey.defense),
        specialAttack: Value<int?>(monkey.specialAttack),
        specialDefense: Value<int?>(monkey.specialDefense),
        speed: Value<int?>(monkey.speed),
        healthPoints: Value<int?>(monkey.healthPoints),
        species: Value<String?>(monkey.species));
  }

  static List<MonkeysCompanion> mapToCompanionList(List<Monkey> monkeys) {
    List<MonkeysCompanion> companions = List.empty(growable: true);

    for (int i = 0; i < monkeys.length; i++) {
      companions.add(mapToCompanion(monkeys[i]));
    }

    return companions;
  }
}
