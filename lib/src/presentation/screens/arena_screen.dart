import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:monkey_mon/src/domain/model/mon.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';
import 'package:monkey_mon/src/domain/usecases/fight_in_arena.dart';
import 'package:monkey_mon/src/presentation/widgets/loading_indicator.dart';
import 'package:monkey_mon/src/presentation/widgets/scaffold_with_background.dart';

class ArenaScreen extends ConsumerWidget {
  ArenaScreen({super.key});

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
            child: _sprite(context),
          ),
          Positioned(
            right: -(MediaQuery.of(context).size.width * 0.05),
            top: MediaQuery.of(context).size.height * 0.15,
            child: _sprite(context),
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
          left: 0,
          bottom: MediaQuery.of(context).size.height * 0.13,
          child: _sprite(context, imageUrl: imageUrlFighter),
        ),
        Positioned(
          right: 0,
          top: MediaQuery.of(context).size.height * 0.02,
          child: _sprite(context, imageUrl: imageUrlOpponent),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.42,
          right: MediaQuery.of(context).size.width * 0.05,
          child: _textBox(context, fighter),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.35,
          left: MediaQuery.of(context).size.width * 0.05,
          child: _textBox(context, opponent),
        ),
      ]),
    );
  }

  Widget _sprite(BuildContext context, {String? imageUrl}) {
    final Image battleTile = Image.asset(
      "assets/images/battle_tile.png",
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.height * 0.35,
      fit: BoxFit.fitHeight,
    );

    final CachedNetworkImage sprite = CachedNetworkImage(
      imageUrl: imageUrl ??
          "https://github.com/PokeAPI/sprites/blob/ca5a7886c10753144e6fae3b69d45a4d42a449b4/sprites/pokemon/0.png",
      fit: BoxFit.fitHeight,
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.height * 0.3,
      imageBuilder: (context, imageProvider) {
        return ImagePixels(
            imageProvider: imageProvider,
            builder: (context, img) {
              int offsetSpriteVertical = 17;
              if (img.hasImage) {
                for (int y = 0; y < img.height!; y++) {
                  for (int x = 0; x < img.width!; x++) {
                    final pixelColor = img.pixelColorAt!(x, y);
                    if (pixelColor.blue != 0 ||
                        pixelColor.red != 0 ||
                        pixelColor.green != 0) {
                      offsetSpriteVertical = y;

                      final translationX =
                          (offsetSpriteVertical.toDouble() * 2.0) -
                              battleTile.height! * 0.1;

                      return Container(
                        transform:
                            Matrix4.translationValues(0, translationX, 0),
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      );
                    }
                  }
                }
              }
              return Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              );
            });
      },
    );
    final double offsetSpriteHorizontal =
        (sprite.width! - battleTile.width!).abs() / 2;

    return SizedBox(
      width: MediaQuery.of(context).size.height * 0.35,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: battleTile,
          ),
          imageUrl != null
              ? Positioned(
                  bottom: 0,
                  left: offsetSpriteHorizontal,
                  child: sprite,
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
      color: Theme.of(context).colorScheme.primary,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.45,
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
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.white),
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
              Text(
                "${mon.currentHp}/$maxHp",
                style: const TextStyle(color: Colors.white),
              ),
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
