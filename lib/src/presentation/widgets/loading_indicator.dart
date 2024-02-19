import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double? value;
  final Animation<Color>? valueColor;
  const LoadingIndicator({super.key, this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator.adaptive(
        value: value,
        valueColor: valueColor,
      ),
    );
  }
}
