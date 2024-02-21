import 'package:auto_size_text_plus/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:monkey_mon/src/presentation/widgets/base_stats_bars.dart';

class MonkeyEntry extends StatelessWidget {
  final MonkeyDto monkeyDto;
  const MonkeyEntry({super.key, required this.monkeyDto});

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.height * 0.25;
    const String placeholderImage =
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/0.png";

    List<Widget> nameWidgetRow = List.empty(growable: true);
    nameWidgetRow.add(
      AutoSizeText(
        monkeyDto.name,
        minFontSize: 25,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    nameWidgetRow.add(const SizedBox(width: 12));

    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const SizedBox(height: 12),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: imageHeight / 2.5,
            child: CachedNetworkImage(
              height: imageHeight,
              imageUrl: monkeyDto.image ?? placeholderImage,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AutoSizeText(
                  monkeyDto.name,
                  minFontSize: 25,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AutoSizeText(
            monkeyDto.description ?? "",
            // minFontSize: 15
            style: const TextStyle(fontSize: 15),
            maxLines: 3,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 4),
          _additionalInfoText("Affen-Spezies", monkeyDto.species?.name),
          _additionalInfoText("Bekannt aus", monkeyDto.knownFrom),
          _additionalInfoText("Stärken", monkeyDto.strength),
          _additionalInfoText("Schwächen", monkeyDto.weaknesses),
          const SizedBox(height: 12),
          const Divider(),
          BaseStatsBars(
            hp: monkeyDto.hp,
            attack: monkeyDto.attack,
            defense: monkeyDto.defense,
            specialAttack: monkeyDto.specialAttack,
            specialDefense: monkeyDto.specialDefense,
            speed: monkeyDto.speed,
          ),
        ],
      ),
    );
  }

  Widget _additionalInfoText(String label, String? infoText) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          infoText != null
              ? RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: "$label: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: infoText,
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
