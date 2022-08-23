import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PhoLoading extends StatelessWidget {
  const PhoLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Lottie.asset(
          'assets/new_ui/animation_lottie/pho_loading_green.json',
          height: 85,
        ),
        // Positioned(
        //   child: Lottie.asset(
        //     'assets/new_ui/animation_lottie/pho.json',
        //     height: 85,
        //   ),
        //   bottom: 20,
        //   left: -35,
        // ),
      ],
    );
  }
}
