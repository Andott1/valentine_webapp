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
  final List<HeartParticle> _staticHearts = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    
    // PRE-CALCULATE HEARTS
    for (int i = 0; i < 15; i++) {
      _staticHearts.add(
        HeartParticle(
          initialX: _random.nextDouble(),
          initialY: _random.nextDouble(),
          speed: _random.nextDouble() * 0.2 + 0.1,
          size: _random.nextDouble() * 15 + 10,
          color: Colors.pinkAccent.withValues(alpha: _random.nextDouble() * 0.5 + 0.2),
        ),
      );
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
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
        // OPTIMIZED BACKGROUND
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: HeartPainter(_staticHearts, _controller.value),
                size: Size.infinite,
              );
            },
          ),
        ),
        widget.child,
      ],
    );
  }
}

class HeartParticle {
  final double initialX;
  final double initialY;
  final double speed;
  final double size;
  final Color color;

  const HeartParticle({required this.initialX, required this.initialY, required this.speed, required this.size, required this.color});
}

class HeartPainter extends CustomPainter {
  final List<HeartParticle> hearts;
  final double progress; // 0.0 to 1.0

  HeartPainter(this.hearts, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var heart in hearts) {
      paint.color = heart.color;
      
      // OPTIMIZED MOVEMENT: Loop position based on progress
      double currentY = (heart.initialY + (progress * heart.speed * 5)) % 1.0;
      
      final dx = heart.initialX * size.width;
      final dy = currentY * size.height;
      final s = heart.size / 3;

      // Draw Pixel Heart
      canvas.drawRect(Rect.fromLTWH(dx - s, dy - s, s, s), paint);
      canvas.drawRect(Rect.fromLTWH(dx + s, dy - s, s, s), paint);
      canvas.drawRect(Rect.fromLTWH(dx - 2*s, dy, 5*s, s), paint);
      canvas.drawRect(Rect.fromLTWH(dx - s, dy + s, 3*s, s), paint);
      canvas.drawRect(Rect.fromLTWH(dx, dy + 2*s, s, s), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}