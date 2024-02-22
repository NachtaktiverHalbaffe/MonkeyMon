// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monkey_mon/src/core/utils/logger.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:monkey_mon/src/domain/usecases/fight_in_arena.dart';
import 'package:monkey_mon/src/domain/usecases/update_monkey.dart';
import 'package:monkey_mon/src/presentation/widgets/monkey_edit_modal_bottomsheet.dart';
import 'package:monkey_mon/src/presentation/widgets/monkey_entry.dart';

class MondexEntryScreen extends ConsumerWidget {
  final MonkeyDto monkeyDto;
  const MondexEntryScreen({super.key, required this.monkeyDto});

  final double buttonPadding = 12;
  final double buttonSpace = 12;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            MonkeyEntry(monkeyDto: monkeyDto),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: buttonPadding),
              child: OutlinedButton(
                  onPressed: () {
                    final arena = ref.read(
                        arenaFightProvider(const Duration(seconds: 1))
                            .notifier);
                    arena.setFighter(monkeyDto: monkeyDto);
                  },
                  child: const ListTile(
                      leading: Icon(MdiIcons.pokemonGo),
                      title: Text("Als Kämpfer in die Arena schicken"))),
            ),
            SizedBox(height: buttonSpace),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: buttonPadding),
              child: OutlinedButton(
                  onPressed: () {
                    final arena = ref.read(
                        arenaFightProvider(const Duration(seconds: 1))
                            .notifier);
                    arena.setOpponent(monkeyDto: monkeyDto);
                  },
                  child: const ListTile(
                      leading: Icon(MdiIcons.pokemonGo),
                      title: Text("Als Gegner in die Arena schicken"))),
            ),
            SizedBox(height: buttonSpace),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: buttonPadding),
              child: OutlinedButton(
                  onPressed: () async {
                    final (payload, image) = await editMonkeyModalBottomSheet(
                        context: context, initialData: monkeyDto);
                    if (payload != null) {
                      getLogger().d("Got payload $payload");
                      final result =
                          ref.read(updateMonkeyProvider(payload, image: image));
                      result.whenData((data) {
                        getLogger()
                            .d("Got response ${data.toString()} from REST API");
                      });

                      return;
                    }
                    getLogger().d("Got empty payload $payload");
                  },
                  child: const ListTile(
                      leading: Icon(MdiIcons.pen),
                      title: Text("Eintrag bearbeiten"))),
            ),
            SizedBox(height: buttonSpace),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: buttonPadding),
              child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const ListTile(
                      leading: Icon(MdiIcons.pokeball),
                      title: Text("Zurück zum Pokedex"))),
            ),
            SizedBox(height: buttonSpace),
          ],
        ),
      ),
    );
  }
}
