import 'package:auto_size_text_plus/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:monkey_mon/src/presentation/widgets/scaffold_with_background.dart';

class SwiperWidget<T> extends StatefulWidget {
  final List<T> items;
  final String? backgroundImage;
  final double? heightScale;
  final double? widthScale;
  final Widget Function(BuildContext, T) cardBuilder;
  final void Function(int) onTap;
  const SwiperWidget(
      {super.key,
      required this.items,
      required this.cardBuilder,
      required this.onTap,
      this.backgroundImage,
      this.heightScale,
      this.widthScale});

  @override
  State<SwiperWidget> createState() => _SwiperWidgetState(
      items,
      cardBuilder,
      onTap,
      backgroundImage ?? "assets/images/pokemon_background.jpg",
      heightScale,
      widthScale);
}

class _SwiperWidgetState<T> extends State<SwiperWidget> {
  final List<T> items;
  final Widget Function(BuildContext, T) cardBuilder;
  final String backgroundImage;
  final double? heightScale;
  final double? widthScale;
  final void Function(int) onTap;

  int currentIndex = 0;

  _SwiperWidgetState(this.items, this.cardBuilder, this.onTap,
      this.backgroundImage, this.heightScale, this.widthScale);

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
      assetPath: backgroundImage,
      child: Column(
        children: [
          SizedBox(
              height: heightScale != null
                  ? MediaQuery.of(context).size.height * (heightScale! - 0.85)
                  : MediaQuery.of(context).size.height * 0.05),
          items.isNotEmpty
              ? Swiper(
                  itemWidth: widthScale != null
                      ? MediaQuery.of(context).size.width * widthScale!
                      : MediaQuery.of(context).size.width * 0.9,
                  itemHeight: heightScale != null
                      ? MediaQuery.of(context).size.height * heightScale!
                      : MediaQuery.of(context).size.height * 0.8,
                  itemCount: items.length,
                  layout: SwiperLayout.TINDER,
                  loop: true,
                  autoplay: true,
                  autoplayDisableOnInteraction: true,
                  itemBuilder: (context, index) {
                    _setCurrentIndex(index);
                    return cardBuilder(context, items[index]);
                  },
                  onTap: (index) => onTap(index),
                  onIndexChanged: (value) {
                    _setCurrentIndex(value);
                  },
                )
              : const Center(),
          const SizedBox(height: 12),
          AutoSizeText(
            "$currentIndex/${items.length}",
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
