import 'package:cancellation_token/cancellation_token.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';
import 'package:monkey_mon/src/domain/usecases/load_pokemons.dart';
import 'package:auto_size_text_plus/auto_size_text.dart';
import 'package:monkey_mon/src/presentation/screens/pokedex_detail_screen.dart';
import 'package:monkey_mon/src/presentation/widgets/animated_pokeball.dart';
import 'package:monkey_mon/src/presentation/widgets/pokemon_entry.dart';

class PokedexScreen extends ConsumerWidget {
  PokedexScreen({super.key});

  final CancellationToken cancellationToken = CancellationToken();
  final List<PokemonDto> pokemons = List.empty(growable: true);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
        .watch(loadPokemonsProvider(cancellationToken: cancellationToken))
        .whenData((value) => pokemons.add(value));

    return Scaffold(
      body: _swiperWidget(context),
    );
  }

  Widget _swiperWidget(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.topCenter,
          image: AssetImage("assets/images/pokemon_background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.075),
          pokemons.isNotEmpty
              ? Swiper(
                  itemWidth: MediaQuery.of(context).size.width * 0.9,
                  itemHeight: MediaQuery.of(context).size.height * 0.8,
                  itemCount: pokemons.length,
                  layout: SwiperLayout.TINDER,
                  loop: true,
                  autoplay: true,
                  autoplayDisableOnInteraction: true,
                  itemBuilder: (context, index) {
                    currentIndex = index;
                    return _card(context, pokemons[index]);
                  },
                  onIndexChanged: (value) => currentIndex = value,
                  onTap: (index) {
                    Navigator.push<PokedexEntryScreen>(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PokedexEntryScreen(
                                pokemonDto: pokemons[index])));
                  },
                )
              : Center(),
          SizedBox(height: 12),
          AutoSizeText(
            "$currentIndex/${pokemons.length}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _card(BuildContext context, PokemonDto pokemonDto) {
    return Card(
        color: PokemonEntry.matchPokemonTypeToColor(pokemonDto.types.last),
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
}
