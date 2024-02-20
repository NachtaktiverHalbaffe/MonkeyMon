import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:monkey_mon/src/domain/usecases/load_monkeys.dart';
import 'package:monkey_mon/src/presentation/widgets/loading_indicator.dart';
import 'package:monkey_mon/src/presentation/widgets/scaffold_with_background.dart';
import 'package:monkey_mon/src/presentation/widgets/swiper_widget.dart';

class MonkeydexScreen extends ConsumerWidget {
  const MonkeydexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadedPokemons = ref.watch(loadMonkeysProvider());

    return loadedPokemons.when(
      data: (data) => SwiperWidget<MonkeyDto>(
        items: data,
        cardBuilder: (context, item) => _card(context, item),
        onTap: (index) {
          // Navigator.push<PokedexEntryScreen>(
          //     context,
          //     MaterialPageRoute(
          //         builder: (_) => PokedexEntryScreen(pokemonDto: data[index])));
        },
      ),
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

Widget _card(BuildContext context, MonkeyDto pokemonDto) {
  return Card(
    margin: const EdgeInsets.only(bottom: 24.0),
    elevation: 8.0,
    child: SizedBox(),
  );
}
