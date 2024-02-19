import 'package:flutter/material.dart';

class ScaffoldWithBackground extends StatelessWidget {
  final String assetPath;
  final Widget? child;
  final BoxFit? fit;
  const ScaffoldWithBackground(
      {super.key,
      required this.assetPath,
      this.child,
      this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topCenter,
            image: AssetImage(assetPath),
            fit: fit,
          ),
        ),
        child: child ?? Container(),
      ),
    );
  }
}
