import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:monkey_mon/src/domain/usecases/create_monkey.dart';
import 'package:monkey_mon/src/domain/usecases/load_monkeys.dart';
import 'package:monkey_mon/src/presentation/screens/mondex_detail_screen.dart';
import 'package:monkey_mon/src/presentation/widgets/loading_indicator.dart';
import 'package:monkey_mon/src/presentation/widgets/monkey_edit_modal_bottomsheet.dart';
import 'package:monkey_mon/src/presentation/widgets/monkey_entry.dart';
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
        heightScale: 0.85,
        cardBuilder: (context, item) => _card(context, item),
        onTap: (index) {
          Navigator.push<MondexEntryScreen>(
              context,
              MaterialPageRoute(
                  builder: (_) => MondexEntryScreen(monkeyDto: data[index])));
        },
        footerChilds: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GestureDetector(
              onTap: () async {
                final (monkeyDto, image) =
                    await editMonkeyModalBottomSheet(context: context);
                if (monkeyDto != null) {
                  ref.read(createMonkeyProvider(monkeyDto, image: image));
                }
              },
              child: Text(
                "+ Eintrag erstellen",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
            )),
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

Widget _card(BuildContext context, MonkeyDto monkeyDto) {
  return Card(
    color: const Color.fromARGB(255, 83, 59, 50),
    margin: const EdgeInsets.only(bottom: 24.0),
    elevation: 8.0,
    child: MonkeyEntry(monkeyDto: monkeyDto),
  );
}
