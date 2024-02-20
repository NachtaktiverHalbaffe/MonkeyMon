import 'package:cancellation_token/cancellation_token.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';
import 'package:monkey_mon/src/domain/usecases/load_pokemons.dart';
import 'package:auto_size_text_plus/auto_size_text.dart';
import 'package:monkey_mon/src/domain/usecases/load_pokemons_oneshot.dart';
import 'package:monkey_mon/src/domain/usecases/pokemon_needs_remote_fetching.dart';
import 'package:monkey_mon/src/presentation/screens/pokedex_detail_screen.dart';
import 'package:monkey_mon/src/presentation/widgets/animated_pokeball.dart';
import 'package:monkey_mon/src/presentation/widgets/loading_indicator.dart';
import 'package:monkey_mon/src/presentation/widgets/pokemon_entry.dart';
import 'package:monkey_mon/src/presentation/widgets/scaffold_with_background.dart';

class PokedexScreen extends ConsumerWidget {
  const PokedexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final needsRemoteFetching = ref.watch(pokemonNeedsRemoteFetchingProvider);

    return needsRemoteFetching.when(
      data: (shouldBeStreamed) {
        if (shouldBeStreamed) {
          return _PokemonScreenStreaming();
        } else {
          return const _PokemonScreenOneshot();
        }
      },
      error: (_, stacktrace) => const ScaffoldWithBackground(
          assetPath: "assets/images/pokemon_background.jpg"),
      loading: () => _loadingWidget(),
    );
  }
}

class _PokemonScreenOneshot extends ConsumerWidget {
  const _PokemonScreenOneshot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadedPokemons = ref.watch(loadPokemonsOneshotProvider);

    return loadedPokemons.when(
      data: (data) {
        return SwiperWidget(pokemons: data);
      },
      error: (_, stacktrace) => const ScaffoldWithBackground(
          assetPath: "assets/images/pokemon_background.jpg"),
      loading: () => _loadingWidget(),
    );
  }
}

class _PokemonScreenStreaming extends ConsumerWidget {
  _PokemonScreenStreaming({super.key});

  final CancellationToken cancellationToken = CancellationToken();
  final List<PokemonDto> pokemons = List.empty(growable: true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadedPokemons = ref.watch(loadPokemonsProvider());

    return loadedPokemons.when(
      data: (data) {
        pokemons.add(data);
        return SwiperWidget(pokemons: pokemons);
      },
      error: (_, stacktrace) => const ScaffoldWithBackground(
          assetPath: "assets/images/pokemon_background.jpg"),
      loading: () => _loadingWidget(),
    );
  }
}

Widget _loadingWidget() {
  return const ScaffoldWithBackground(
      assetPath: "assets/images/pokemon_background.jpg",
      child: LoadingIndicator());
}

class SwiperWidget extends StatefulWidget {
  final List<PokemonDto> pokemons;
  const SwiperWidget({super.key, required this.pokemons});

  @override
  State<SwiperWidget> createState() => _SwiperWidgetState(pokemons);
}

class _SwiperWidgetState extends State<SwiperWidget> {
  final List<PokemonDto> pokemons;

  int currentIndex = 0;
  final SwiperController controller = SwiperController();

  _SwiperWidgetState(this.pokemons);

  void _setCurrentIndex(int index) {
    Future.delayed(Duration.zero, () async {
      if (this.mounted) {
        setState(() {
          currentIndex = index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
      assetPath: "assets/images/pokemon_background.jpg",
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          pokemons.isNotEmpty
              ? Swiper(
                  controller: controller,
                  itemWidth: MediaQuery.of(context).size.width * 0.9,
                  itemHeight: MediaQuery.of(context).size.height * 0.8,
                  itemCount: pokemons.length,
                  layout: SwiperLayout.TINDER,
                  loop: true,
                  autoplay: true,
                  autoplayDisableOnInteraction: true,
                  itemBuilder: (context, index) {
                    _setCurrentIndex(index);
                    return _card(context, pokemons[index]);
                  },
                  onTap: (index) {
                    Navigator.push<PokedexEntryScreen>(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PokedexEntryScreen(
                                pokemonDto: pokemons[index])));
                  },
                  onIndexChanged: (value) {
                    _setCurrentIndex(value);
                  },
                )
              : const Center(),
          const SizedBox(height: 12),
          AutoSizeText(
            "$currentIndex/${pokemons.length}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 6.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 6.0,
                  color: Color.fromARGB(125, 0, 0, 255),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget _card(BuildContext context, PokemonDto pokemonDto) {
  return Card(
      color: PokemonEntry.matchPokemonTypeToColor(pokemonDto.types.first)
          .darken(30),
      margin: const EdgeInsets.only(bottom: 24.0),
      elevation: 8.0,
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -30,
            child: AnimatedPokeballWidget(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withOpacity(0.3),
                size: MediaQuery.of(context).size.height * 0.25 * 0.7),
          ),
          PokemonEntry(pokemonDto: pokemonDto),
        ],
      ));
}

extension ColorExtension on Color {
  /// Darken a color by [percent] amount (100 = black)
// ........................................................
  Color darken([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(this.alpha, (this.red * f).round(),
        (this.green * f).round(), (this.blue * f).round());
  }

  /// Lighten a color by [percent] amount (100 = white)
// ........................................................
  Color lighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        this.alpha,
        this.red + ((255 - this.red) * p).round(),
        this.green + ((255 - this.green) * p).round(),
        this.blue + ((255 - this.blue) * p).round());
  }
}
