// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';

class BaseStatsBars extends StatelessWidget {
  final PokemonDto pokemon;

  const BaseStatsBars({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseStatsItemWidget(
            pokemon: pokemon,
            maxValue: 300,
            title: "Kp",
          ),
          BaseStatsItemWidget(
            pokemon: pokemon,
            title: "Angriff",
          ),
          BaseStatsItemWidget(
            pokemon: pokemon,
            title: "Verteidigung",
          ),
          BaseStatsItemWidget(
            pokemon: pokemon,
            title: "Sp. Angriff",
          ),
          BaseStatsItemWidget(
            pokemon: pokemon,
            title: "Sp. Verteidigung",
          ),
          BaseStatsItemWidget(
            pokemon: pokemon,
            title: "Initiative",
          ),
        ],
      ),
    );
  }
}

class BaseStatsItemWidget extends StatelessWidget {
  final String title;
  final int maxValue;
  final PokemonDto pokemon;

  const BaseStatsItemWidget(
      {Key? key,
      required this.title,
      required this.pokemon,
      this.maxValue = 200})
      : super(key: key);

  double get barPercentage => value() / maxValue;

  int value() {
    switch (title.toLowerCase()) {
      case "kp":
        return pokemon.hp;
      case "angriff":
        return pokemon.attack;
      case "verteidigung":
        return pokemon.defense;
      case "sp. angriff":
        return pokemon.specialAttack;
      case "sp. verteidigung":
        return pokemon.specialDefense;
      case "initiative":
        return pokemon.speed;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 135,
            child: Opacity(
              opacity: 0.7,
              child: Text(title, style: textTheme.bodyText1),
            ),
          ),
          Container(
            width: 40,
            child: Text(
              value().toString(),
              style: textTheme.bodyText1,
            ),
          ),
          Flexible(
            flex: 1,
            child: Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Color(0xFFF4F5F4),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  //color: Colors.red,
                ),
                FractionallySizedBox(
                  widthFactor: barPercentage,
                  child: AnimatedContainer(
                    duration: Duration(seconds: 3),
                    height: 10,
                    decoration: BoxDecoration(
                      color: baseStatsBar(barPercentage),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color baseStatsBar(double percentage) {
    if (percentage < 0.1666) {
      return const Color(0xFFF34544);
    } else if (percentage < 0.3332) {
      return const Color(0xFFFF7F0F);
    } else if (percentage < 0.4998) {
      return const Color(0xFFFFDD57);
    } else if (percentage < 0.6664) {
      return const Color(0xFFA1E515);
    } else if (percentage < 0.833) {
      return const Color(0xFF22CD5E);
    } else {
      return const Color(0xFF00C2B7);
    }
  }
}
