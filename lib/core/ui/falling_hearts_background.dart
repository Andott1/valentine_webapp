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

  // 24 FPS Logic
  final int _fps = 24;
  final int _durationSeconds = 60;

  @override
  void initState() {
    super.initState();
    
    for (int i = 0; i < 15; i++) {
      _staticHearts.add(
        HeartParticle(
          initialX: _random.nextDouble(),
          initialY: _random.nextDouble(),
          speed: _random.nextDouble() * 0.2 + 0.1,
          size: _random.nextDouble() * 15 + 10,
          color: Colors.pinkAccent.withValues(alpha: _random.nextDouble() * 0.5 + 0.2),
          rotationSpeed: (_random.nextDouble() - 0.5) * 4.0, // Hearts spin faster!
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
              double t = _controller.value;
              int totalFrames = _fps * _durationSeconds;
              double discreteT = (t * totalFrames).floor() / totalFrames;

              return CustomPaint(
                painter: HeartPainter(_staticHearts, discreteT),
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
  final double rotationSpeed;   // NEW
  final double initialRotation; // NEW

  const HeartParticle({
    required this.initialX, 
    required this.initialY, 
    required this.speed, 
    required this.size, 
    required this.color,
    required this.rotationSpeed,
    required this.initialRotation,
  });
}

class HeartPainter extends CustomPainter {
  final List<HeartParticle> hearts;
  final double progress; 

  HeartPainter(this.hearts, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var heart in hearts) {
      paint.color = heart.color;
      
      // Calculate discrete position
      double currentY = (heart.initialY + (progress * heart.speed * 5)) % 1.0;
      double currentRotation = heart.initialRotation + (progress * heart.rotationSpeed * 6.28);
      
      final dx = heart.initialX * size.width;
      final dy = currentY * size.height;
      final s = heart.size / 3;

      // SAVE CANVAS STATE
      canvas.save();
      
      // MOVE TO HEART CENTER
      canvas.translate(dx, dy);
      
      // ROTATE
      canvas.rotate(currentRotation);
      
      // DRAW SHAPE (Relative to 0,0 center)
      // Top bumps
      canvas.drawRect(Rect.fromLTWH(-s, -s, s, s), paint);
      canvas.drawRect(Rect.fromLTWH(s, -s, s, s), paint);
      // Middle
      canvas.drawRect(Rect.fromLTWH(-2*s, 0, 5*s, s), paint);
      // Bottom
      canvas.drawRect(Rect.fromLTWH(-s, s, 3*s, s), paint);
      canvas.drawRect(Rect.fromLTWH(0, 2*s, s, s), paint);

      // RESTORE CANVAS (So next heart isn't rotated by this one)
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}