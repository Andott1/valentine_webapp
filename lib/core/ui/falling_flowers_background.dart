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
  
  // FIXED LIST: We generate these ONCE and reuse them forever.
  final List<FlowerParticle> _staticFlowers = [];
  final Random _random = Random();
  
  // Weighted list logic (Kept same as before)
  final List<int> _weightedFlowerIndices = [
    1, 2, 3, 4, 5, 6, 6, 6, 7, 8, 9, 9, 9, 10, 11, 11, 11, 12
  ];

  @override
  void initState() {
    super.initState();
    
    // 1. GENERATE PARTICLES ONCE (Pre-calculation)
    // We create 20 fixed flowers with random start positions.
    for (int i = 0; i < 20; i++) {
      int imgIdx = _weightedFlowerIndices[_random.nextInt(_weightedFlowerIndices.length)];
      _staticFlowers.add(
        FlowerParticle(
          initialX: _random.nextDouble(),
          // Spread them out vertically (0.0 to 1.0) so they don't clump
          initialY: _random.nextDouble(), 
          // Constant speed for this specific flower
          speed: _random.nextDouble() * 0.2 + 0.05, 
          size: _random.nextDouble() * 30 + 35, // Big sizes (35-65)
          asset: 'assets/flowers/$imgIdx.png',
        ),
      );
    }
    
    // 2. THE LOOP CONTROLLER
    // Instead of resetting, this controller just runs 0 -> 1 over and over.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // Long loop for variety
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
        // LAYER 1: THE FLOWERS
        // RepaintBoundary helps performance by isolating this layer
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: _staticFlowers.map((flower) {
                  // DETERMINISTIC MOVEMENT LOGIC
                  // Current Y = (Start Y + (Time * Speed)) % 1.0
                  // This wraps around automatically without creating new objects!
                  double currentY = (flower.initialY + (_controller.value * flower.speed * 5)) % 1.0;
                  // We add -0.1 to allow it to "enter" from the top cleanly
                  // But for simple wrapping, just mapping 0..1 to ScreenHeight is faster.
                  
                  return Positioned(
                    left: flower.initialX * MediaQuery.of(context).size.width,
                    top: currentY * MediaQuery.of(context).size.height - 50, // -50 to start slightly offscreen
                    child: Image.asset(
                      flower.asset,
                      width: flower.size,
                      height: flower.size,
                      filterQuality: FilterQuality.none,
                      gaplessPlayback: true, // Prevents flickering
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        
        // LAYER 2: THE PIXEL "FROST" OVERLAY
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

// Simplified Class (Immutable for performance)
class FlowerParticle {
  final double initialX;
  final double initialY;
  final double speed;
  final double size;
  final String asset;
  
  const FlowerParticle({
    required this.initialX, 
    required this.initialY, 
    required this.speed, 
    required this.size, 
    required this.asset
  });
}