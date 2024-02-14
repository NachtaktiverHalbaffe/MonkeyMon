import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';

class PokemonSpriteConverter extends TypeConverter<PokemonSprites, String> {
  const PokemonSpriteConverter();

  @override
  PokemonSprites fromSql(String fromDb) {
    return PokemonSprites.fromJson(json.decode(fromDb));
  }

  @override
  String toSql(PokemonSprites value) {
    return json.encode(value.toJson());
  }
}
