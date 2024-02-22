import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:monkey_mon/src/data/datasources/pokemon_remote_datasource.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = HttpCertOverrides();
  if (kDebugMode) {
    Logger.level = Level.debug;
  } else {
    Logger.level = Level.warning;
  }

  runApp(const ProviderScope(child: MyApp()));
}
