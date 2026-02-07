import 'package:flutter/material.dart';

class PixelTextContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const PixelTextContainer({
    super.key, 
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        // MILKY FROSTED GLASS EFFECT
        color: Colors.white.withValues(alpha: 0.7), // Semi-transparent white
        
        // CUTE PASTEL BORDER
        border: Border.all(color: const Color(0xFFF48FB1), width: 4), // Pink border
        
        // SOFT SHADOW
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF880E4F), // Deep pink shadow
            offset: Offset(4, 4), 
            blurRadius: 0 // Keep it pixelated/sharp
          ),
        ],
      ),
      child: child,
    );
  }
}