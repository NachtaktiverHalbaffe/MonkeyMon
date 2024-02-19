import 'package:drift/drift.dart';
import 'package:monkey_mon/src/data/datasources/app_database.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';
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

Map<String, dynamic> generateMonkeyApiAllMonkeysEmpty() {
  return {
    "content": [],
    "pageable": {
      "pageNumber": 0,
      "pageSize": 20,
      "sort": {"empty": true, "unsorted": true, "sorted": false},
      "offset": 0,
      "paged": true,
      "unpaged": false
    },
    "totalPages": 0,
    "totalElements": 0,
    "last": true,
    "size": 20,
    "number": 0,
    "sort": {"empty": true, "unsorted": true, "sorted": false},
    "numberOfElements": 0,
    "first": true,
    "empty": true
  };
}

Map<String, dynamic> generateMonkeyApiAllMonkeys() {
  return {
    "content": [
      {
        "id": 1,
        "name": "Panferno",
        "known_from": "Pokemon",
        "description":
            "Dieses mächtige Pokémon hat ein erhabenes Antlitz. Im Kampf hüllt es sich in Flammen und seine Bewegungen gleichen eine Tanz – ein wahrhaft unvergesslicher Anblick!",
        "strength": "Offensive",
        "weaknesses": "Wasser",
        "attack": 191,
        "defense": 132,
        "special_attack": 191,
        "special_defense": 132,
        "speed": 198,
        "health_points": 262,
        "image": "http://localhost:8080/api/v1/imagepool/392.png",
        "species_name": "Orang-utan",
        "species_content": {
          "name": "Orang-utan",
          "taxonomy": {
            "genus": "Pongo",
            "class": "Mammalia",
            "family": "Hominidae",
            "order": "Primates",
            "scientific_name":
                "Pongo pygmaeus, Pongo abelii, Pongo tapanuliensis",
            "kingdom": "Animalia",
            "phylum": "Chordata"
          },
          "locations": ["Asia"],
          "characteristics": {
            "prey": "Fruits, Bark, Insects",
            "habitat": "Lowland tropical forest",
            "number_of_species": "3",
            "height": "1.25m - 1.5m (4ft - 5ft)",
            "group_behavior": "Solitary",
            "estimated_population_size": "20,000",
            "weight": "30kg - 90kg (66lbs - 200lbs)",
            "color": "BrownGreyRedBlackOrange",
            "most_distinctive_feature": "Red hair and longer arms than legs",
            "lifestyle": "Diurnal",
            "location": "Borneo and Sumatra",
            "lifespan": "30 - 40 years",
            "age_of_sexual_maturity": "12 - 15 years",
            "age_of_weaning": "3 years",
            "common_name": "Orang-utan",
            "name_of_young": "Infant",
            "predators": "Human, Tiger, Clouded Leopard",
            "other_name(s)": "Red Ape, Forest Person",
            "gestation_period": "9 months",
            "group": "Mammal",
            "biggest_threat": "Hunting and Habitat Loss",
            "slogan": "Shares 97% of its DNA with humans!",
            "skin_type": "Hair",
            "top_speed": "2.7 mph",
            "diet": "Omnivore",
            "average_litter_size": "1"
          }
        }
      }
    ],
    "pageable": {
      "pageNumber": 0,
      "pageSize": 20,
      "sort": {"empty": true, "unsorted": true, "sorted": false},
      "offset": 0,
      "paged": true,
      "unpaged": false
    },
    "totalPages": 1,
    "totalElements": 1,
    "last": true,
    "size": 20,
    "number": 0,
    "sort": {"empty": true, "unsorted": true, "sorted": false},
    "numberOfElements": 1,
    "first": true,
    "empty": false
  };
}

Map<String, dynamic> generateMonkeyApiOneMonkey() {
  return {
    "id": 1,
    "name": "Panferno",
    "known_from": "Pokemon",
    "description":
        "Dieses mächtige Pokémon hat ein erhabenes Antlitz. Im Kampf hüllt es sich in Flammen und seine Bewegungen gleichen eine Tanz – ein wahrhaft unvergesslicher Anblick!",
    "strength": "Offensive",
    "weaknesses": "Wasser",
    "attack": 191,
    "defense": 132,
    "special_attack": 191,
    "special_defense": 132,
    "speed": 198,
    "health_points": 262,
    "image": "http://localhost:8080/api/v1/imagepool/392.png",
    "species_name": "Orang-utan",
    "species_content": {
      "name": "Orang-utan",
      "taxonomy": {
        "genus": "Pongo",
        "class": "Mammalia",
        "family": "Hominidae",
        "order": "Primates",
        "scientific_name": "Pongo pygmaeus, Pongo abelii, Pongo tapanuliensis",
        "kingdom": "Animalia",
        "phylum": "Chordata"
      },
      "locations": ["Asia"],
      "characteristics": {
        "prey": "Fruits, Bark, Insects",
        "habitat": "Lowland tropical forest",
        "number_of_species": "3",
        "height": "1.25m - 1.5m (4ft - 5ft)",
        "group_behavior": "Solitary",
        "estimated_population_size": "20,000",
        "weight": "30kg - 90kg (66lbs - 200lbs)",
        "color": "BrownGreyRedBlackOrange",
        "most_distinctive_feature": "Red hair and longer arms than legs",
        "lifestyle": "Diurnal",
        "location": "Borneo and Sumatra",
        "lifespan": "30 - 40 years",
        "age_of_sexual_maturity": "12 - 15 years",
        "age_of_weaning": "3 years",
        "common_name": "Orang-utan",
        "name_of_young": "Infant",
        "predators": "Human, Tiger, Clouded Leopard",
        "other_name(s)": "Red Ape, Forest Person",
        "gestation_period": "9 months",
        "group": "Mammal",
        "biggest_threat": "Hunting and Habitat Loss",
        "slogan": "Shares 97% of its DNA with humans!",
        "skin_type": "Hair",
        "top_speed": "2.7 mph",
        "diet": "Omnivore",
        "average_litter_size": "1"
      }
    }
  };
}

PokemonDto generatePokemonDto() {
  return const PokemonDto(
    id: 392,
    name: "Panferno",
    description:
        "Seine Krone aus Feuer ist Zeichen seines feurigen Wesens. Niemand ist schneller im Kampf als dieses Pokémon.",
    attack: 104,
    hp: 76,
    defense: 71,
    specialAttack: 104,
    specialDefense: 71,
    speed: 108,
    types: ["fire", "fighting"],
    sprites: PokemonSprites(
      frontDefault:
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/392.png",
      frontShiny:
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/392.png",
      backDefault:
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/392.png",
      backShiny:
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/392.png",
    ),
  );
}

Pokemon generatePokemon() {
  final pokemonDto = generatePokemonDto();
  return Pokemon(
      id: pokemonDto.id,
      name: pokemonDto.name,
      description: pokemonDto.description,
      attack: pokemonDto.attack,
      defense: pokemonDto.defense,
      specialAttack: pokemonDto.specialAttack,
      specialDefense: pokemonDto.specialDefense,
      speed: pokemonDto.speed,
      hp: pokemonDto.hp,
      types: pokemonDto.types,
      sprites: pokemonDto.sprites);
}

PokemonsCompanion generatePokemonCompanion() {
  final pokemonDto = generatePokemonDto();
  return PokemonsCompanion(
      id: Value<int>(pokemonDto.id),
      name: Value<String>(pokemonDto.name),
      description: Value<String?>(pokemonDto.description),
      attack: Value<int>(pokemonDto.attack),
      defense: Value<int>(pokemonDto.defense),
      specialAttack: Value<int>(pokemonDto.specialAttack),
      specialDefense: Value<int>(pokemonDto.specialDefense),
      speed: Value<int>(pokemonDto.speed),
      hp: Value<int>(pokemonDto.hp),
      types: Value<List<String>>(pokemonDto.types),
      sprites: Value<PokemonSprites?>(pokemonDto.sprites));
}
