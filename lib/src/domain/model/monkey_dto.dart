import 'package:freezed_annotation/freezed_annotation.dart';

import 'species_dto.dart';

part "monkey_dto.freezed.dart";
part "monkey_dto.g.dart";

@freezed
class MonkeyDto with _$MonkeyDto {
  const factory MonkeyDto({
    required int id,
    required String name,
    String? knownFrom,
    String? description,
    String? strength,
    String? weaknesses,
    String? image,
    @Default(0) int attack,
    @Default(0) int defense,
    @Default(0) int specialAttack,
    @Default(0) int specialDefense,
    @Default(0) int speed,
    @Default(0) int hp,
    SpeciesDto? species,
  }) = _MonkeyDto;

  factory MonkeyDto.fromJson(Map<String, dynamic> json) =>
      _$MonkeyDtoFromJson(json);
}
