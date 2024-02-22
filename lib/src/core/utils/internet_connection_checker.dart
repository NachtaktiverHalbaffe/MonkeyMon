import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "internet_connection_checker.g.dart";

class MockInternetChecker extends _$InternetConnectionChecker
    with Mock
    implements InternetConnectionChecker {}

@riverpod
class InternetConnectionChecker extends _$InternetConnectionChecker {
  late StreamSubscription listener;
  @override
  Future<bool> build() async {
    listener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          state = const AsyncValue.data(true);
          break;
        case InternetStatus.disconnected:
          state = const AsyncValue.data(false);
          break;
      }
    });
    return await InternetConnection().hasInternetAccess;
  }

  Future<void> stopListening() async {
    await listener.cancel();
  }

  Future<bool> isConnected() async {
    return await InternetConnection().hasInternetAccess;
  }
}
