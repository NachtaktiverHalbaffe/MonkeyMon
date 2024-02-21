// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class BaseStatsBars extends StatelessWidget {
  final int? hp;
  final int? attack;
  final int? defense;
  final int? specialAttack;
  final int? specialDefense;
  final int? speed;

  const BaseStatsBars(
      {super.key,
      this.hp,
      this.attack,
      this.defense,
      this.specialAttack,
      this.specialDefense,
      this.speed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseStatsItemWidget(
            hp: hp,
            maxValue: 300,
            title: "Kp",
          ),
          BaseStatsItemWidget(
            attack: attack,
            title: "Angriff",
          ),
          BaseStatsItemWidget(
            defense: defense,
            title: "Verteidigung",
          ),
          BaseStatsItemWidget(
            specialAttack: specialAttack,
            title: "Sp. Angriff",
          ),
          BaseStatsItemWidget(
            specialDefense: specialDefense,
            title: "Sp. Verteidigung",
          ),
          BaseStatsItemWidget(
            speed: speed,
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
  final int? hp;
  final int? attack;
  final int? defense;
  final int? specialAttack;
  final int? specialDefense;
  final int? speed;

  const BaseStatsItemWidget(
      {Key? key,
      required this.title,
      this.maxValue = 200,
      this.hp,
      this.attack,
      this.defense,
      this.specialAttack,
      this.specialDefense,
      this.speed})
      : super(key: key);

  double get barPercentage => value() / maxValue;

  int value() {
    switch (title.toLowerCase()) {
      case "kp":
        return hp ?? 0;
      case "angriff":
        return attack ?? 0;
      case "verteidigung":
        return defense ?? 0;
      case "sp. angriff":
        return specialAttack ?? 0;
      case "sp. verteidigung":
        return specialDefense ?? 0;
      case "initiative":
        return speed ?? 0;
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
                    color: const Color(0xFFF4F5F4),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  //color: Colors.red,
                ),
                FractionallySizedBox(
                  widthFactor: barPercentage <= 1.0 ? barPercentage : 1.0,
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
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
