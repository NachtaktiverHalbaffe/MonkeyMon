import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonkeydexScreen extends ConsumerWidget {
  const MonkeydexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Center(child: Text("Mondex")),
    );
  }
}
