import 'dart:convert';

import 'package:drift/drift.dart';

class MapTypeConverter<K, V> extends TypeConverter<Map<K, V>, String> {
  @override
  Map<K, V> fromSql(String fromDb) {
    return Map<K, V>.from(json.decode(fromDb) as Map<K, V>);
  }

  @override
  String toSql(Map<K, V> value) {
    return json.encode(value);
  }
}
