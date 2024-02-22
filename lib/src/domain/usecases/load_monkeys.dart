import 'package:monkey_mon/src/core/utils/logger.dart';
import 'package:monkey_mon/src/data/repository/monkey_repository_impl.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:monkey_mon/src/domain/repository/monkey_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "load_monkeys.g.dart";

@riverpod
class LoadMonkeys extends _$LoadMonkeys {
  late final MonkeyRepository repository;

  @override
  Future<List<MonkeyDto>> build({String? baseUrl}) async {
    getLogger().d("Performing use case 'LoadMonkey'");
    repository =
        ref.read(monkeyRepositoryImplProvider(baseUrl: baseUrl).notifier);
    final monkeys = await repository.getAllMonkeys();
    getLogger().d("Got result in use case 'LoadMonkey'. Result: $monkeys");
    return monkeys;
  }
}
