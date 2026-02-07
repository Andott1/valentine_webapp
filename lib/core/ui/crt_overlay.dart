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

        // 2. The Scanline Effect (IgnorePointer lets clicks pass through)
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.5, 0.5], // Creates sharp lines
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.05), // Very subtle darkening every other pixel
                ],
                tileMode: TileMode.repeated,
              ),
            ),
            // We scale the background to be small (e.g., 4px high) so it repeats thousands of times
          ),
        ),
        
        // 3. Optional: Vignette (Dark corners)
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.2),
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