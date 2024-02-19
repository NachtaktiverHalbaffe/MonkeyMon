// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';
import 'package:monkey_mon/src/presentation/widgets/pokemon_entry.dart';

class PokedexEntryScreen extends ConsumerWidget {
  final PokemonDto pokemonDto;
  const PokedexEntryScreen({super.key, required this.pokemonDto});

  final double buttonPadding = 12;
  final double buttonSpace = 12;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            PokemonEntry(pokemonDto: pokemonDto),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: buttonPadding),
              child: OutlinedButton(
                  onPressed: () {},
                  child: const ListTile(
                      leading: Icon(MdiIcons.pokemonGo),
                      title: Text("Als Kämpfer in die Arena schicken"))),
            ),
            SizedBox(height: buttonSpace),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: buttonPadding),
              child: OutlinedButton(
                  onPressed: () {},
                  child: const ListTile(
                      leading: Icon(MdiIcons.pokemonGo),
                      title: Text("Als Gegner in die Arena schicken"))),
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
