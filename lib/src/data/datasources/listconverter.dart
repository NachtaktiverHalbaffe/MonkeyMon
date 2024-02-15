import 'dart:convert';

import 'package:drift/drift.dart';

class ListTypeConverter<T extends Object>
    extends TypeConverter<List<T>, String> {
  @override
  List<T> fromSql(String fromDb) {
    return (json.decode(fromDb) as List<dynamic>).map((e) => e as T).toList();
  }

  @override
  String toSql(List<T> value) {
    return json.encode(value);
  }
}
