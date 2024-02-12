import 'package:drift/drift.dart';
import 'package:monkey_mon/src/data/datasources/app_database.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:monkey_mon/src/domain/model/species_dto.dart';

MonkeyDto generateMonkeyDto() {
  return const MonkeyDto(
    id: 2,
    name: "Panferno",
    knownFrom: "Pokemon",
    description:
        """Dieses mächtige Pokémon hat ein erhabenes Antlitz. Im Kampf hüllt es sich in Flammen 
          und seine Bewegungen gleichen einem Tanz - ein wahrhaft unvergesslicher Anblick!""",
    strength: "Feuer, Kampf",
    weaknesses: "Wasser, Flug, Boden, Psycho",
    attack: 337,
    defense: 265,
    specialAttack: 337,
    specialDefense: 265,
    speed: 346,
    healthPoints: 356,
  );
}

MonkeyDto generateMonkeyDtoWithSpeciesData() {
  return MonkeyDto(
    id: 2,
    name: "Panferno",
    knownFrom: "Pokemon",
    description:
        """Dieses mächtige Pokémon hat ein erhabenes Antlitz. Im Kampf hüllt es sich in Flammen 
          und seine Bewegungen gleichen einem Tanz - ein wahrhaft unvergesslicher Anblick!""",
    strength: "Feuer, Kampf",
    weaknesses: "Wasser, Flug, Boden, Psycho",
    attack: 337,
    defense: 265,
    specialAttack: 337,
    specialDefense: 265,
    speed: 346,
    healthPoints: 356,
    species: generateSpeciesDto(),
  );
}

MonkeysCompanion generateMonkeyCompanion() {
  final MonkeyDto monkeyDto = generateMonkeyDto();
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
    healthPoints: Value<int?>(monkeyDto.healthPoints),
  );
}

MonkeysCompanion generateMonkeyCompanionWithSpeciesData() {
  final MonkeyDto monkeyDto = generateMonkeyDto();
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
      healthPoints: Value<int?>(monkeyDto.healthPoints),
      species: generateSpeciesCompanion().name);
}

Monkey generateMonkey() {
  final MonkeyDto monkeyDto = generateMonkeyDto();
  return Monkey(
    id: monkeyDto.id,
    name: monkeyDto.name,
    knownFrom: monkeyDto.knownFrom,
    description: monkeyDto.description,
    strength: monkeyDto.strength,
    weaknesses: monkeyDto.weaknesses,
    attack: monkeyDto.attack,
    defense: monkeyDto.defense,
    specialAttack: monkeyDto.specialAttack,
    specialDefense: monkeyDto.specialDefense,
    speed: monkeyDto.speed,
    healthPoints: monkeyDto.healthPoints,
  );
}

Monkey generateMonkeyWithSpeciesData() {
  final MonkeyDto monkeyDto = generateMonkeyDto();
  return Monkey(
      id: monkeyDto.id,
      name: monkeyDto.name,
      knownFrom: monkeyDto.knownFrom,
      description: monkeyDto.description,
      strength: monkeyDto.strength,
      weaknesses: monkeyDto.weaknesses,
      attack: monkeyDto.attack,
      defense: monkeyDto.defense,
      specialAttack: monkeyDto.specialAttack,
      specialDefense: monkeyDto.specialDefense,
      speed: monkeyDto.speed,
      healthPoints: monkeyDto.healthPoints,
      species: generateSpeciesDto().name);
}

SpeciesDto generateSpeciesDto() {
  return const SpeciesDto(
    name: "Cheetah",
    taxonomy: {
      "kingdom": "Animalia",
      "phylum": "Chordata",
      "class": "Mammalia",
      "order": "Carnivora",
      "family": "Felidae",
      "genus": "Acinonyx",
      "scientific_name": "Acinonyx jubatus"
    },
    locations: ["Africa", "Asia", "Eurasia"],
    characteristics: {
      "prey": "Gazelle, Wildebeest, Hare",
      "name_of_young": "Cub",
      "group_behavior": "Solitary/Pairs",
      "estimated_population_size": "8,500",
      "biggest_threat": "Habitat loss",
      "most_distinctive_feature": "Yellowish fur covered in small black spots",
      "gestation_period": "90 days",
      "habitat": "Open grassland",
      "diet": "Carnivore",
      "average_litter_size": "3",
      "lifestyle": "Diurnal",
      "common_name": "Cheetah",
      "number_of_species": "5",
      "location": "Asia and Africa",
      "slogan": "The fastest land mammal in the world!",
      "group": "Mammal",
      "color": "BrownYellowBlackTan",
      "skin_type": "Fur",
      "top_speed": "70 mph",
      "lifespan": "10 - 12 years",
      "weight": "40kg - 65kg (88lbs - 140lbs)",
      "height": "115cm - 136cm (45in - 53in)",
      "age_of_sexual_maturity": "20 - 24 months",
      "age_of_weaning": "3 months"
    },
  );
}

SpeciesCompanion generateSpeciesCompanion() {
  final SpeciesDto species = generateSpeciesDto();
  return SpeciesCompanion(
    name: Value<String>(species.name),
    taxonomy: Value<Map<String, String>?>(species.taxonomy),
    locations: Value<List<String>?>(species.locations),
    characteristics: Value<Map<String, String>?>(species.characteristics),
  );
}

SingleSpecies generateSingleSpecies() {
  final SpeciesDto species = generateSpeciesDto();
  return SingleSpecies(
    name: species.name,
    taxonomy: species.taxonomy,
    locations: species.locations,
    characteristics: species.characteristics,
  );
}
