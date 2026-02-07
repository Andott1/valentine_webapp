import 'dart:math';
import 'package:flutter/material.dart';

class FallingFlowersBackground extends StatefulWidget {
  final Widget child;
  const FallingFlowersBackground({super.key, required this.child});

  @override
  State<FallingFlowersBackground> createState() => _FallingFlowersBackgroundState();
}

class _FallingFlowersBackgroundState extends State<FallingFlowersBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<FlowerParticle> _flowers = [];
  final Random _random = Random();
  
  // Weighted list: 6, 9, 11 appear 3x more
  final List<int> _weightedFlowerIndices = [
    1, 2, 3, 4, 5, 6, 6, 6, 7, 8, 9, 9, 9, 10, 11, 11, 11, 12
  ];

  @override
  void initState() {
    super.initState();
    // Generate particles
    for (int i = 0; i < 25; i++) { // Increased count slightly
      _flowers.add(_generateFlower(true));
    }
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  FlowerParticle _generateFlower(bool randomY) {
    int idx = _weightedFlowerIndices[_random.nextInt(_weightedFlowerIndices.length)];
    return FlowerParticle(
      id: UniqueKey(),
      x: _random.nextDouble(),
      y: randomY ? _random.nextDouble() : -0.3, // Start higher up
      speed: _random.nextDouble() * 0.002 + 0.001, 
      // >>> CHANGE 1: BIGGER SIZES <<<
      size: _random.nextDouble() * 30 + 35, // Range: 35px to 65px
      asset: 'assets/flowers/$idx.png',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // LAYER 1: THE FLOWERS
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: _flowers.map((flower) {
                flower.y += flower.speed;
                if (flower.y > 1.1) {
                   flower.y = -0.3; // Reset higher
                   flower.x = _random.nextDouble();
                }

                return Positioned(
                  left: flower.x * MediaQuery.of(context).size.width,
                  top: flower.y * MediaQuery.of(context).size.height,
                  child: Image.asset(
                    flower.asset,
                    width: flower.size,
                    height: flower.size,
                    filterQuality: FilterQuality.none, // Keep pixels sharp
                  ),
                );
              }).toList(),
            );
          },
        ),
        
        // LAYER 2: THE PIXEL "FROST" OVERLAY
        // A subtle, semi-transparent wash over the background.
        // The global CRT overlay will give this texture.
        IgnorePointer(
          child: Container(
            color: Colors.white.withValues(alpha: 0.25),
          ),
        ),

        // LAYER 3: THE APP CONTENT
        widget.child,
      ],
    );
  }
}

class FlowerParticle {
  Key id;
  double x; double y; double speed; double size; String asset;
  FlowerParticle({required this.id, required this.x, required this.y, required this.speed, required this.size, required this.asset});
}