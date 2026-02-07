import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/ui/pixel_window.dart';

class LoveLetterWindow extends StatelessWidget {
  const LoveLetterWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: PixelWindow(
        title: "Love_Letter.txt",
        color: const Color(0xFFFFCDD2), // Light Red/Pink
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. THE ANIMATED HEART
              Image.asset(
                'assets/heart_animated.gif',
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              
              // 2. THE LETTER
              Text(
                "Dearest Player 2,\n\n"
                "If you are reading this, you found the secret level! "
                "I just wanted to say that you are my favorite person to co-op with. "
                "Every day with you feels like a bonus stage.\n\n"
                "I can't wait to celebrate with you.\n\n"
                "Love,\nPlayer 1",
                style: GoogleFonts.jersey10(
                  fontSize: 24,
                  color: const Color(0xFF880E4F),
                  height: 1.2,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}