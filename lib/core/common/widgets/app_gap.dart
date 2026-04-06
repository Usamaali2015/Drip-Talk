import 'package:flutter/material.dart';

class AppGap extends StatelessWidget {
  final double size;
  final Axis axis;

  const AppGap(this.size, {super.key, this.axis = Axis.vertical});

  @override
  Widget build(BuildContext context) {
    return axis == Axis.vertical
        ? SizedBox(height: size)
        : SizedBox(width: size);
  }
}
