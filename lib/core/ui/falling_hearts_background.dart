import 'dart:math';
import 'package:flutter/material.dart';

class FallingHeartsBackground extends StatefulWidget {
  final Widget child;
  const FallingHeartsBackground({super.key, required this.child});

  @override
  State<FallingHeartsBackground> createState() => _FallingHeartsBackgroundState();
}

class _FallingHeartsBackgroundState extends State<FallingHeartsBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<HeartParticle> _hearts = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // Infinite loop

    // Initialize 20 hearts with random starting positions
    for (int i = 0; i < 20; i++) {
      _hearts.add(_generateHeart(true));
    }
  }

  HeartParticle _generateHeart(bool randomY) {
    return HeartParticle(
      x: _random.nextDouble(), // 0.0 to 1.0 (screen width)
      y: randomY ? _random.nextDouble() : -0.1, // Start above screen if new
      speed: _random.nextDouble() * 0.2 + 0.1, // Random fall speed
      size: _random.nextDouble() * 15 + 10, // Random size 10-25px
      color: Colors.pinkAccent.withValues(alpha: _random.nextDouble() * 0.5 + 0.2),
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
        // 1. The Animated Background
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Update positions
              for (var heart in _hearts) {
                heart.y += heart.speed * 0.01; // Move down
                if (heart.y > 1.1) {
                  // Reset if it goes off bottom
                  var newHeart = _generateHeart(false);
                  heart.x = newHeart.x;
                  heart.y = newHeart.y;
                  heart.speed = newHeart.speed;
                }
              }
              return CustomPaint(
                painter: HeartPainter(_hearts),
              );
            },
          ),
        ),
        // 2. The Screen Content
        widget.child,
      ],
    );
  }
}

class HeartParticle {
  double x;
  double y;
  double speed;
  double size;
  Color color;

  HeartParticle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.color,
  });
}

class HeartPainter extends CustomPainter {
  final List<HeartParticle> hearts;

  HeartPainter(this.hearts);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var heart in hearts) {
      paint.color = heart.color;
      // Convert normalized (0.0-1.0) coordinates to pixels
      final dx = heart.x * size.width;
      final dy = heart.y * size.height;
      
      // Draw a simple pixel-heart or just a square for retro feel
      // Let's draw a small pixel-like square cluster to mimic a heart
      final s = heart.size / 3;
      
      // Top two bumps
      canvas.drawRect(Rect.fromLTWH(dx - s, dy - s, s, s), paint);
      canvas.drawRect(Rect.fromLTWH(dx + s, dy - s, s, s), paint);
      // Middle row
      canvas.drawRect(Rect.fromLTWH(dx - 2*s, dy, 5*s, s), paint);
      // Bottom tapered rows
      canvas.drawRect(Rect.fromLTWH(dx - s, dy + s, 3*s, s), paint);
      canvas.drawRect(Rect.fromLTWH(dx, dy + 2*s, s, s), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}