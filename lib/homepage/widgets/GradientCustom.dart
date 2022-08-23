import 'package:flutter/material.dart';

class LinearGradientMaskHome extends StatelessWidget {
  final Widget child;
  LinearGradientMaskHome({Key? key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return RadialGradient(
          center: Alignment.topCenter,
          radius: 1,
          colors: [Colors.blue, Colors.purple],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
