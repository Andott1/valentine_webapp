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
  final List<FlowerParticle> _staticFlowers = [];
  final Random _random = Random();
  
  // 24 FPS Logic
  // Duration is 20 seconds. 24 frames per second * 20 seconds = 480 total frames.
  final int _fps = 24;
  final int _durationSeconds = 60;

  final List<int> _weightedFlowerIndices = [
    1, 2, 3, 4, 5, 6, 6, 6, 7, 8, 9, 9, 9, 10, 11, 11, 11, 12
  ];

  @override
  void initState() {
    super.initState();
    
    // 1. GENERATE PARTICLES (Now with Rotation!)
    for (int i = 0; i < 20; i++) {
      int imgIdx = _weightedFlowerIndices[_random.nextInt(_weightedFlowerIndices.length)];
      _staticFlowers.add(
        FlowerParticle(
          initialX: _random.nextDouble(),
          initialY: _random.nextDouble(),
          speed: _random.nextDouble() * 0.2 + 0.05,
          size: _random.nextDouble() * 30 + 35,
          asset: 'assets/flowers/$imgIdx.png',
          // Random rotation speed (negative = left spin, positive = right spin)
          rotationSpeed: (_random.nextDouble() - 0.5) * 2.0, 
          initialRotation: _random.nextDouble() * 2 * pi,
        ),
      );
    }
    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _durationSeconds),
    )..repeat();
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
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // --- 24 FPS LOCK ---
              // We snap the smooth time (0.0 -> 1.0) to grid steps
              double t = _controller.value;
              int totalFrames = _fps * _durationSeconds;
              double discreteT = (t * totalFrames).floor() / totalFrames;

              return Stack(
                children: _staticFlowers.map((flower) {
                  // Position Logic
                  double currentY = (flower.initialY + (discreteT * flower.speed * 5)) % 1.0;
                  
                  // Rotation Logic
                  double currentRotation = flower.initialRotation + (discreteT * flower.rotationSpeed * 6.28);

                  return Positioned(
                    left: flower.initialX * MediaQuery.of(context).size.width,
                    top: currentY * MediaQuery.of(context).size.height - 50,
                    child: Transform.rotate(
                      angle: currentRotation,
                      child: Image.asset(
                        flower.asset,
                        width: flower.size,
                        height: flower.size,
                        filterQuality: FilterQuality.none,
                        gaplessPlayback: true,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        
        IgnorePointer(
          child: Container(color: Colors.white.withValues(alpha: 0.25)),
        ),
        widget.child,
      ],
    );
  }
}

class FlowerParticle {
  final double initialX;
  final double initialY;
  final double speed;
  final double size;
  final String asset;
  final double rotationSpeed;   // NEW
  final double initialRotation; // NEW
  
  const FlowerParticle({
    required this.initialX, 
    required this.initialY, 
    required this.speed, 
    required this.size, 
    required this.asset,
    required this.rotationSpeed,
    required this.initialRotation,
  });
}