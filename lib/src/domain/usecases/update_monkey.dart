import 'package:monkey_mon/src/data/repository/monkey_repository_impl.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:monkey_mon/src/domain/repository/monkey_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_monkey.g.dart';

@riverpod
class UpdateMonkey extends _$UpdateMonkey {
  late MonkeyRepository repository;

  @override
  Future<MonkeyDto?> build(MonkeyDto monkeyDto) async {
    repository = ref.read(monkeyRepositoryImplProvider.notifier);
    return await repository.updateMonkey(monkeyDto: monkeyDto);
  }
}
