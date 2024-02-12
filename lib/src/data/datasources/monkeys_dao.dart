import 'package:drift/drift.dart';
import 'package:monkey_mon/src/data/datasources/app_database.dart';

import '../entity/monkeys.dart';
part "monkeys_dao.g.dart";

@DriftAccessor(tables: [Monkeys])
class MonkeysDao extends DatabaseAccessor<AppDatabase> with _$MonkeysDaoMixin {
  MonkeysDao(super.db);

  Future<Monkey?> createMonkey(MonkeysCompanion monkey) async {
    return into(monkeys)
        .insertReturningOrNull(monkey, mode: InsertMode.insertOrIgnore);
  }

  Future<List<Monkey>> getAllMonkeys() async {
    return await select(monkeys).get();
  }

  Future<Monkey?> getMonkey(int id) async {
    return await (select(monkeys)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<Monkey?> updateMonkey(MonkeysCompanion updateData) async {
    final List<Monkey> updatedMonkeys = await (update(monkeys)
          ..where((tbl) => tbl.id.equals(updateData.id.value)))
        .writeReturning(updateData);

    if (updatedMonkeys.isEmpty) {
      return null;
    } else {
      return updatedMonkeys.first;
    }
  }

  Future<int> deleteMonkey(int id) async {
    return await (delete(monkeys)..where((tbl) => tbl.id.equals(id))).go();
  }
}
