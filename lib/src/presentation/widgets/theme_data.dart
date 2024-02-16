import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
  colorScheme: const ColorScheme.dark()
      .copyWith(primary: const Color.fromARGB(255, 139, 15, 6)),
);

ThemeData lightTheme = ThemeData.light(useMaterial3: true).copyWith(
  colorScheme: const ColorScheme.light()
      .copyWith(primary: Color.fromARGB(255, 189, 23, 11)),
);
