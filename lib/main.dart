import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monkey_mon/src/data/datasources/pokemon_remote_datasource.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = HttpCertOverrides();
  runApp(const ProviderScope(child: MyApp()));
}
