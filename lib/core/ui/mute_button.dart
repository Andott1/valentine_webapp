import 'package:flutter/material.dart';
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
    // 1. Determine State Colors
    // Active (Music On): Retro Cyan
    // Muted (Music Off): Grey/Red
    final bool isMuted = SoundService.isMuted;
    
    final Color mainColor = isMuted 
        ? const Color(0xFFEF9A9A) // Red 200 (Muted)
        : const Color(0xFF81C784); // Cyan 200 (Active)
        
    final Color shadowColor = isMuted
        ? const Color(0xFFC62828) // Red 800
        : const Color(0xFF388E3C); // Cyan 700

    // 2. Button Dimensions
    const double size = 44.0;
    const double depth = 4.0;
    
    // 3. Animation Offset
    final double offset = _isPressed ? depth : 0.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        SoundService.toggleMute();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: SizedBox(
        width: size,
        height: size + depth, // Account for the 3D depth
        child: Stack(
          children: [
            // LAYER 1: The Black Outline (Bottom Base)
            Positioned(
              top: depth,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            
            // LAYER 2: The Dark Shadow (Depth)
            Positioned(
              top: depth, // Static shadow position
              child: Container(
                width: size,
                height: size, // Full height to fill the gap when unpressed
                decoration: BoxDecoration(
                  color: shadowColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
            ),

            // LAYER 3: The Face (The part that moves)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 50),
              top: offset, // Moves down when pressed
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Stack(
                  children: [
                    // Little Highlight Shine (Top Left)
                    Positioned(
                      top: 4, left: 4,
                      child: Container(
                        width: 8, height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // The Icon
                    Center(
                      child: Icon(
                        isMuted ? Icons.music_off : Icons.music_note,
                        color: Colors.white,
                        size: 20,
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