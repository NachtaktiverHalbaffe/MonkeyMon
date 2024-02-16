import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:theme_manager/theme_manager.dart';

class BottonNavBar extends StatelessWidget {
  final _controller = NotchBottomBarController(index: 0);
  final Function(int) onTap;

  BottonNavBar({super.key, required this.onTap});

  final _bottombarItems = [
    const BottomBarItem(
      inActiveItem: Icon(
        MdiIcons.pokeball,
      ),
      activeItem: Icon(
        MdiIcons.pokeball,
        color: Colors.redAccent,
      ),
      itemLabel: 'Pokedex',
    ),
    const BottomBarItem(
      inActiveItem: Icon(
        MdiIcons.cardBulleted,
      ),
      activeItem: Icon(
        MdiIcons.cardBulleted,
        color: Colors.brown,
      ),
      itemLabel: 'Mondex',
    ),
    const BottomBarItem(
      inActiveItem: Icon(
        MdiIcons.pokemonGo,
      ),
      activeItem: Icon(
        MdiIcons.pokemonGo,
        color: Colors.blue,
      ),
      itemLabel: 'Arena',
    ),
    const BottomBarItem(
      inActiveItem: Icon(
        MdiIcons.cog,
      ),
      activeItem: Icon(
        MdiIcons.cog,
        color: Colors.black,
      ),
      itemLabel: 'Einstellungen',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedNotchBottomBar(
      color: Theme.of(context).colorScheme.primary,
      notchBottomBarController: _controller,
      bottomBarItems: _bottombarItems,
      bottomBarWidth: MediaQuery.of(context).size.width,
      onTap: onTap,
      kIconSize: 24.0,
      shadowElevation:
          ThemeManager.of(context).brightness == Brightness.light ? 8 : 0,
      kBottomRadius: 28.0,
      itemLabelStyle:
          Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 8),
    );
  }
}
