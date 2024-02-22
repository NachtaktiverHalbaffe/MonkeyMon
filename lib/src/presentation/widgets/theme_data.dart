// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';

const Color primaryColor = Color.fromARGB(255, 139, 15, 6);

ThemeData darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
  colorScheme: const ColorScheme.dark().copyWith(
    primary: primaryColor,
    secondary: primaryColor.lighten(10),
  ),
  textSelectionTheme:
      ThemeData.dark(useMaterial3: true).textSelectionTheme.copyWith(
            selectionColor: primaryColor,
            selectionHandleColor: primaryColor,
            cursorColor: primaryColor,
          ),
);

ThemeData lightTheme = ThemeData.light(useMaterial3: true).copyWith(
  cardColor: const Color.fromARGB(255, 196, 193, 193),
  colorScheme: const ColorScheme.light().copyWith(
    primary: primaryColor,
    surface: const Color.fromARGB(255, 196, 193, 193),
    secondary: primaryColor.lighten(30),
  ),
  textSelectionTheme:
      ThemeData.light(useMaterial3: true).textSelectionTheme.copyWith(
            selectionColor: primaryColor,
            selectionHandleColor: primaryColor,
            cursorColor: primaryColor,
          ),
);

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
