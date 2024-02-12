import 'package:freezed_annotation/freezed_annotation.dart';

part "species_dto.freezed.dart";
part "species_dto.g.dart";

@freezed
class SpeciesDto with _$SpeciesDto {
  const factory SpeciesDto(
      {required String name,
      Map<String, String>? taxonomy,
      List<String>? locations,
      Map<String, String>? characteristics}) = _SpeciesDto;

  factory SpeciesDto.fromJson(Map<String, dynamic> json) =>
      _$SpeciesDtoFromJson(json);
}
