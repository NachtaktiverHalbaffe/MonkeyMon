import 'package:monkey_mon/src/data/repository/monkey_repository_impl.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:monkey_mon/src/domain/repository/monkey_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "create_monkey.g.dart";

@riverpod
class CreateMonkey extends _$CreateMonkey {
  late MonkeyRepository repository;

  @override
  Future<MonkeyDto?> build(MonkeyDto monkey) async {
    repository = ref.read(monkeyRepositoryImplProvider.notifier);
    return await repository.createMonkey(monkeyDto: monkey);
  }
}
