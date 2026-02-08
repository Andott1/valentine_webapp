import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/sound_service.dart';

class MuteButton extends StatefulWidget {
  const MuteButton({super.key});

  @override
  State<MuteButton> createState() => _MuteButtonState();
}

class _MuteButtonState extends State<MuteButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isMuted = SoundService.isMuted;
    
    // --- COLORS ---
    // Active (Music On): Vibrant Retro Green
    final Color mainColor = isMuted 
        ? const Color(0xFFEF9A9A) // Red 200 (Muted)
        : const Color(0xFF66BB6A); // Green 400 (Active)
        
    final Color shadowColor = isMuted
        ? const Color(0xFFC62828) // Red 800
        : const Color(0xFF2E7D32); // Green 800

    // --- DIMENSIONS ---
    const double width = 140.0; // Much wider for text
    const double height = 44.0;
    const double depth = 4.0;
    
    final double offset = _isPressed ? depth : 0.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        SoundService.toggleMute();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: SizedBox(
        width: width,
        height: height + depth,
        child: Stack(
          children: [
            // LAYER 1: Shadow (Bottom)
            Positioned(
              top: depth,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: shadowColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
            ),

            // LAYER 2: Face (Top)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 50),
              top: offset,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Icon(
                      isMuted ? Icons.music_off : Icons.music_note,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    // Text
                    Text(
                      isMuted ? "MUSIC OFF" : "MUSIC ON",
                      style: GoogleFonts.jersey10(
                        color: Colors.white,
                        fontSize: 24,
                        height: 1.0, // Tight line height for pixel font
                        shadows: [
                          const Shadow(
                            color: Colors.black26, 
                            offset: Offset(1, 1),
                          )
                        ]
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