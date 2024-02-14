import 'package:freezed_annotation/freezed_annotation.dart';

part "pokemon_dto.freezed.dart";
part "pokemon_dto.g.dart";

@freezed
class PokemonDto with _$PokemonDto {
  const factory PokemonDto(
      {required int id,
      required String name,
      required int attack,
      required int hp,
      required int defense,
      required int specialAttack,
      required int specialDefense,
      required int speed,
      required List<String> types,
      String? description,
      PokemonSprites? sprites}) = _PokemonDto;

  factory PokemonDto.fromJson(Map<String, dynamic> json) =>
      _$PokemonDtoFromJson(json);
}

@freezed
class PokemonSprites with _$PokemonSprites {
  const factory PokemonSprites({
    String? frontDefault,
    String? frontShiny,
    String? frontFemale,
    String? frontShinyFemale,
    String? backDefault,
    String? backShiny,
    String? backFemale,
    String? backShinyFemale,
  }) = _PokemonSprites;

  factory PokemonSprites.fromJson(Map<String, dynamic> json) =>
      _$PokemonSpritesFromJson(json);
}
