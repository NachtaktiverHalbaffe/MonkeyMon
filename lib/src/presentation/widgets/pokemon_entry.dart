import 'package:auto_size_text_plus/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';
import 'package:monkey_mon/src/presentation/widgets/base_stats_bars.dart';

class PokemonEntry extends StatelessWidget {
  final PokemonDto pokemonDto;
  const PokemonEntry({super.key, required this.pokemonDto});

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.height * 0.25;

    List<Widget> nameWidgetRow = List.empty(growable: true);
    nameWidgetRow.add(
      AutoSizeText(
        pokemonDto.name,
        minFontSize: 25,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    nameWidgetRow.add(const SizedBox(width: 12));

    for (String type in pokemonDto.types) {
      nameWidgetRow.add(_pokemonTypeChip(type));
    }
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
              imageUrl: pokemonDto.sprites != null
                  ? pokemonDto.sprites!.frontDefault!
                  : "",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: nameWidgetRow,
            ),
          ),
          const SizedBox(height: 12),
          AutoSizeText(
            pokemonDto.description ?? "",
            minFontSize: 15,
            maxLines: 3,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          const Divider(),
          BaseStatsBars(pokemon: pokemonDto),
        ],
      ),
    );
  }

  static Color matchPokemonTypeToColor(String type) {
    switch (type.toLowerCase()) {
      case 'normal':
        return const Color(0xFFA7A877);
      case 'fire':
        return const Color.fromARGB(255, 250, 62, 29);
      case 'water':
        return const Color(0xFF77BDFE);
      case 'grass':
        return const Color.fromARGB(255, 8, 216, 60);
      case 'electric':
        return const Color.fromARGB(255, 255, 231, 0);
      case 'ice':
        return const Color(0xFF99D7D8);
      case 'fighting':
        return const Color(0xFFC03128);
      case 'poison':
        return const Color(0xFF9F419F);
      case 'ground':
        return const Color(0xFFE1C068);
      case 'flying':
        return const Color(0xFFA890F0);
      case 'psychic':
        return const Color(0xFFF95887);
      case 'bug':
        return const Color(0xFFA8B91F);
      case 'rock':
        return const Color(0xFFB8A038);
      case 'ghost':
        return const Color(0xFF705998);
      case 'dark':
        return const Color(0xFF6F5848);
      case 'dragon':
        return const Color(0xFF7138F8);
      case 'steel':
        return const Color(0xFFB8B8D0);
      case 'fairy':
        return const Color(0xFFA890F0);
      default:
        return Colors.grey;
    }
  }

  String _translateType(String type) {
    switch (type.toLowerCase()) {
      case 'normal':
        return "Normal";
      case 'fire':
        return "Feuer";
      case 'water':
        return "Wasser";
      case 'grass':
        return "Pflanze";
      case 'electric':
        return "Elektro";
      case 'ice':
        return "Eis";
      case 'fighting':
        return "Kampf";
      case 'poison':
        return "Gift";
      case 'ground':
        return "Boden";
      case 'flying':
        return "Flug";
      case 'psychic':
        return "Psycho";
      case 'bug':
        return "Käfer";
      case 'rock':
        return "Gestein";
      case 'ghost':
        return "Geist";
      case 'dark':
        return "Unlicht";
      case 'dragon':
        return "Drache";
      case 'steel':
        return "Stahl";
      case 'fairy':
        return "Fee";
      default:
        return "";
    }
  }

  Widget _pokemonTypeChip(String type) {
    return Container(
      padding: const EdgeInsets.only(right: 12),
      child: Chip(
        elevation: 0.0,
        side: const BorderSide(style: BorderStyle.solid, color: Colors.grey),
        shadowColor: Colors.black,
        shape: const StadiumBorder(side: BorderSide(style: BorderStyle.none)),
        avatar: Image(
          image: AssetImage("assets/images/$type.png"),
        ),
        label: Text(_translateType(type).capitalize()),
        backgroundColor: matchPokemonTypeToColor(type),
      ),
    );
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
