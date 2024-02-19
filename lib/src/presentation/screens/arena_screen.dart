import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monkey_mon/src/domain/model/mon.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';
import 'package:monkey_mon/src/domain/usecases/fight_in_arena.dart';
import 'package:monkey_mon/src/presentation/widgets/loading_indicator.dart';
import 'package:monkey_mon/src/presentation/widgets/scaffold_with_background.dart';

class ArenaScreen extends ConsumerWidget {
  const ArenaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(arenaFightProvider(const Duration(seconds: 1))).when(
        data: (data) {
          return _battleField(context, fighter: data.$1, opponent: data.$2);
        },
        error: (_, stacktrace) => _battleFieldEmpty(context),
        loading: () => _loadingScreen());
  }

  Widget _loadingScreen() {
    return const ScaffoldWithBackground(
      assetPath: "assets/images/arena_background.jpg",
      fit: BoxFit.fitHeight,
      child: LoadingIndicator(),
    );
  }

  Widget _battleFieldEmpty(BuildContext context) {
    return ScaffoldWithBackground(
      assetPath: "assets/images/arena_background.jpg",
      fit: BoxFit.fitHeight,
      child: Stack(
        children: [
          Positioned(
            left: MediaQuery.of(context).size.width * 0.02,
            bottom: MediaQuery.of(context).size.height * 0.13,
            child: _fighter(context),
          ),
          Positioned(
            right: -(MediaQuery.of(context).size.width * 0.05),
            top: MediaQuery.of(context).size.height * 0.15,
            child: _opponent(context),
          ),
        ],
      ),
    );
  }

  Widget _battleField(BuildContext context,
      {required Mon fighter, required Mon opponent}) {
    final String? imageUrlFighter, imageUrlOpponent;

    if (fighter.mon is PokemonDto) {
      imageUrlFighter = (fighter.mon as PokemonDto).sprites != null
          ? (fighter.mon as PokemonDto).sprites!.backDefault
          : "";
    } else {
      imageUrlFighter = (fighter.mon as MonkeyDto).image;
    }

    if (opponent.mon is PokemonDto) {
      imageUrlOpponent = (opponent.mon as PokemonDto).sprites != null
          ? (opponent.mon as PokemonDto).sprites!.frontDefault
          : "";
    } else {
      imageUrlOpponent = (opponent.mon as MonkeyDto).image;
    }

    return ScaffoldWithBackground(
      assetPath: "assets/images/arena_background.jpg",
      fit: BoxFit.fitHeight,
      child: Stack(children: [
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.25,
          right: MediaQuery.of(context).size.width * 0.05,
          child: _textBox(context, fighter),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          left: MediaQuery.of(context).size.width * 0.05,
          child: _textBox(context, opponent),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width * 0.02,
          bottom: MediaQuery.of(context).size.height * 0.13,
          child: _fighter(context, imageUrl: imageUrlFighter),
        ),
        Positioned(
          right: -(MediaQuery.of(context).size.width * 0.05),
          top: MediaQuery.of(context).size.height * 0.15,
          child: _opponent(context, imageUrl: imageUrlOpponent),
        ),
      ]),
    );
  }

  Widget _fighter(BuildContext context, {String? imageUrl}) {
    return SizedBox(
      width: 400,
      height: 400,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              "assets/images/battle_tile.png",
              scale: 0.5,
            ),
          ),
          imageUrl != null
              ? Positioned(
                  bottom: -(MediaQuery.of(context).size.height * 0.05),
                  left: MediaQuery.of(context).size.width * 0.06,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    height: 300,
                    width: 200,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _opponent(BuildContext context, {String? imageUrl}) {
    return SizedBox(
      width: 400,
      height: 400,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.16,
            right: MediaQuery.of(context).size.width * 0.05,
            child: Image.asset(
              "assets/images/battle_tile.png",
              scale: 0.5,
            ),
          ),
          imageUrl != null
              ? Positioned(
                  top: -(MediaQuery.of(context).size.width * 0.06),
                  right: MediaQuery.of(context).size.width * 0.1,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    height: 300,
                    width: 200,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _textBox(BuildContext context, Mon mon) {
    final String name;
    final int maxHp;

    if (mon.mon is PokemonDto) {
      name = (mon.mon as PokemonDto).name;
    } else {
      name = (mon.mon as MonkeyDto).name;
    }

    if (mon.mon is PokemonDto) {
      maxHp = (mon.mon as PokemonDto).hp;
    } else {
      maxHp = (mon.mon as MonkeyDto).hp;
    }

    return Card(
      elevation: 12,
      color: Colors.white,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.4,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.02,
                    right: MediaQuery.of(context).size.width * 0.02,
                    top: MediaQuery.of(context).size.height * 0.01),
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
                vertical: MediaQuery.of(context).size.height * 0.01),
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
                  widthFactor: mon.currentHp > 0 ? mon.currentHp / maxHp : 0,
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 3),
                    height: 10,
                    decoration: BoxDecoration(
                      color: baseStatsBar(mon.currentHp / maxHp),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("${mon.currentHp}/$maxHp"),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            ],
          )
        ]),
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
    } else {
      return Color.fromARGB(255, 7, 197, 54);
    }
  }
}
