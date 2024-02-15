import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/model/pokemon_dto.dart';

class PokemonSpriteConverter extends TypeConverter<PokemonSprites, String> {
  @override
  PokemonSprites fromSql(String fromDb) {
    return PokemonSprites.fromJson(json.decode(fromDb));
  }

  @override
  String toSql(PokemonSprites value) {
    return json.encode(value.toJson());
  }
}
