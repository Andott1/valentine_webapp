import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/sound_service.dart';

class PixelButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color mainColor;
  final Color shadowColor;
  final Color highlightColor;
  final bool isLocked;

  const PixelButton({
    super.key,
    required this.text,
    this.onPressed,
    // NEW PASTEL DEFAULTS
    this.mainColor = const Color(0xFFFF80AB),      // Soft Pink
    this.shadowColor = const Color(0xFFC51162),    // Deep Rose (Depth)
    this.highlightColor = const Color(0xFFFF4081), // Hot Pink (Highlight)
    this.isLocked = false,
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _isPressed = false;
  final double _buttonDepth = 6.0;

  @override
  Widget build(BuildContext context) {
    // Locked logic: Use muted mauve/grey instead of industrial grey
    final mainColor = widget.isLocked ? const Color(0xFFCFD8DC) : widget.mainColor;
    final shadowColor = widget.isLocked ? const Color(0xFF90A4AE) : widget.shadowColor;
    final highlightColor = widget.isLocked ? const Color(0xFFECEFF1) : widget.highlightColor;
    
    // Use dark burgundy for outline instead of stark black
    final outlineColor = const Color(0xFF4A0033); 

    final offset = (_isPressed || widget.isLocked) ? _buttonDepth : 0.0;

    return GestureDetector(
      onTapDown: (_) {
        if (!widget.isLocked) {
          setState(() => _isPressed = true);
          SoundService.playClick(); 
        }
      },
      onTapUp: (_) {
        if (!widget.isLocked) {
          setState(() => _isPressed = false);
          widget.onPressed?.call();
        }
      },
      onTapCancel: () => !widget.isLocked ? setState(() => _isPressed = false) : null,
      child: SizedBox(
        height: 64,
        width: 220,
        child: Stack(
          children: [
            // Layer 1: Outline
            Positioned.fill(
              top: _buttonDepth,
              child: Container(
                decoration: BoxDecoration(
                  color: outlineColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            // Layer 2: Depth
            Positioned(
              left: 0, right: 0, bottom: 0, top: _buttonDepth,
              child: Container(
                decoration: BoxDecoration(
                  color: shadowColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: outlineColor, width: 3),
                ),
              ),
            ),
            // Layer 3: Face
            AnimatedPositioned(
              duration: const Duration(milliseconds: 50),
              curve: Curves.easeInOut,
              left: 0, right: 0,
              top: offset,
              bottom: _buttonDepth - offset,
              child: Container(
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: outlineColor, width: 3),
                ),
                child: Stack(
                  children: [
                    // Highlight Strip
                    Positioned(
                      top: 4, left: 6, right: 6, height: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          color: highlightColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.isLocked) const Icon(Icons.lock, color: Colors.white70, size: 24),
                          if (widget.isLocked) const SizedBox(width: 8),
                          Text(
                            widget.text,
                            style: GoogleFonts.jersey10(
                              fontSize: 32,
                              color: Colors.white,
                              shadows: [Shadow(color: outlineColor.withValues(alpha: 0.5), offset: const Offset(2, 2))]
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}