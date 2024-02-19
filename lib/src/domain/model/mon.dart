import 'package:freezed_annotation/freezed_annotation.dart';

part "mon.freezed.dart";
part "mon.g.dart";

@Freezed(genericArgumentFactories: true)
class Mon<T> with _$Mon<T> {
  const factory Mon({
    required int currentHp,
    @Default(false) bool isDefeated,
    T? mon,
  }) = _Mon;

  factory Mon.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$MonFromJson<T>(json, fromJsonT);
}
