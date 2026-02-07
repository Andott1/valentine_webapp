import 'dart:math';
import 'package:flutter/material.dart';

class FlipWidget extends StatelessWidget {
  final Widget front;
  final Widget back;
  final AnimationController controller;

  const FlipWidget({
    super.key,
    required this.front,
    required this.back,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // 0.0 -> 0.5 (Front visible), 0.5 -> 1.0 (Back visible)
        bool isFront = controller.value < 0.5;
        
        // Calculate rotation angle (0 to Pi)
        double angle = controller.value * pi;
        
        // Matrix transformation for 3D effect
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective
          ..rotateY(angle);

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: isFront
              ? front
              : Transform(
                  // We must flip the back image horizontally so it isn't mirrored
                  transform: Matrix4.identity()..rotateY(pi),
                  alignment: Alignment.center,
                  child: back,
                ),
        );
      },
    );
  }
}