import 'dart:convert';

import 'package:drift/drift.dart';



class ListTypeConverter<T extends Object> extends TypeConverter<List<T>, String> {
  @override
  List<T> fromSql(String fromDb) {
    return List<T>.from(json.decode(fromDb) as List<T>);
  }

  @override
  String toSql(List<T> value) {
    return json.encode(value);
  }
}