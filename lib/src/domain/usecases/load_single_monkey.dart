import 'package:monkey_mon/src/data/repository/monkey_repository_impl.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:monkey_mon/src/domain/repository/monkey_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "load_single_monkey.g.dart";

@riverpod
class LoadSingleMonkey extends _$LoadSingleMonkey {
  late final MonkeyRepository repository;

  @override
  Future<MonkeyDto?> build(int id, {String? baseUrl}) async {
    repository =
        ref.read(monkeyRepositoryImplProvider(baseUrl: baseUrl).notifier);
    return await repository.getMonkey(id);
  }
}
