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
    int? attack,
    int? defense,
    int? specialAttack,
    int? specialDefense,
    int? speed,
    int? healthPoints,
    SpeciesDto? species,
  }) = _MonkeyDto;

  factory MonkeyDto.fromJson(Map<String, dynamic> json) =>
      _$MonkeyDtoFromJson(json);
}
