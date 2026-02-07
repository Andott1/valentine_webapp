import 'package:flutter/material.dart';

class CrtOverlay extends StatelessWidget {
  final Widget child;

  const CrtOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. The Actual App Content
        child,

        // 2. The Scanline Effect (Using CustomPainter for accuracy)
        IgnorePointer(
          child: CustomPaint(
            painter: ScanlinePainter(),
            child: Container(), // Fills the screen
          ),
        ),
        
        // 3. Vignette (Dark corners) - Made softer
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5, // Larger radius so it doesn't crush the center
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.15), // Subtle darkness
                ],
                stops: const [0.6, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// This draws a line every 4 pixels
class ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}