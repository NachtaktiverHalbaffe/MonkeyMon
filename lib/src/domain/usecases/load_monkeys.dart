import 'package:monkey_mon/src/data/repository/monkey_repository_impl.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:monkey_mon/src/domain/repository/monkey_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "load_monkeys.g.dart";

@Riverpod(keepAlive: true)
class LoadMonkeys extends _$LoadMonkeys {
  late final MonkeyRepository repository;

  @override
  Future<List<MonkeyDto>> build() async {
    repository = ref.read(monkeyRepositoryImplProvider.notifier);
    return await repository.getAllMonkeys();
  }
}
