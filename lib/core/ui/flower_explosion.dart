import 'dart:math';
import 'package:flutter/material.dart';

class FlowerExplosion extends StatefulWidget {
  final VoidCallback onComplete;
  const FlowerExplosion({super.key, required this.onComplete});

  @override
  State<FlowerExplosion> createState() => _FlowerExplosionState();
}

class _FlowerExplosionState extends State<FlowerExplosion> with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<ExplosionParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // Create 50 particles
    for (int i = 0; i < 50; i++) {
      _particles.add(_generateParticle());
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // 2 seconds explosion
    );

    _controller.forward().whenComplete(() {
      widget.onComplete();
    });
  }

  ExplosionParticle _generateParticle() {
    double angle = _random.nextDouble() * 2 * pi;
    double speed = _random.nextDouble() * 200 + 100; // Fast explosion speed
    // Use weighted random flowers (6, 9, 11 more common)
    List<int> weighted = [1, 2, 3, 4, 5, 6, 6, 6, 7, 8, 9, 9, 9, 10, 11, 11, 11, 12];
    int imgIndex = weighted[_random.nextInt(weighted.length)];

    return ExplosionParticle(
      angle: angle,
      speed: speed,
      size: _random.nextDouble() * 30 + 10,
      asset: 'assets/flowers/$imgIndex.png',
      rotationSpeed: (_random.nextDouble() - 0.5) * 0.2,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: _particles.map((p) {
            // Physics: Move outwards + Gravity
            double t = _controller.value;
            // Ease out cubic for explosion (fast start, slow end)
            double dist = p.speed * (1 - pow(1 - t, 3).toDouble()) * 3; 
            
            double dx = cos(p.angle) * dist;
            double dy = sin(p.angle) * dist + (200 * t * t); // Add gravity (dy increases)

            return Positioned(
              left: MediaQuery.of(context).size.width / 2 + dx - p.size / 2,
              top: MediaQuery.of(context).size.height / 2 + dy - p.size / 2,
              child: Transform.rotate(
                angle: p.rotationSpeed * t * 20,
                child: Opacity(
                  opacity: (1 - t).clamp(0.0, 1.0), // Fade out
                  child: Image.asset(
                    p.asset,
                    width: p.size,
                    height: p.size,
                    filterQuality: FilterQuality.none,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class ExplosionParticle {
  double angle;
  double speed;
  double size;
  String asset;
  double rotationSpeed;
  ExplosionParticle({required this.angle, required this.speed, required this.size, required this.asset, required this.rotationSpeed});
}