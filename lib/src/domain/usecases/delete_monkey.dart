import 'package:monkey_mon/src/data/repository/monkey_repository_impl.dart';
import 'package:monkey_mon/src/domain/repository/monkey_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "delete_monkey.g.dart";

@riverpod
class DeleteMonkey extends _$DeleteMonkey {
  late MonkeyRepository repository;

  @override
  Future<bool> build(int id) async {
    repository = ref.read(monkeyRepositoryImplProvider.notifier);
    return await repository.deleteMonkey(id);
  }
}
