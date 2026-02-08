import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mute_button.dart';

class TopStatusBar extends StatelessWidget {
  const TopStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        border: const Border(
          bottom: BorderSide(color: Colors.black, width: 3),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, offset: Offset(0, 4), blurRadius: 4),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. LEFT: OS Name
          const Icon(Icons.favorite_rounded, color: Color(0xFFD81B60), size: 24),
          const SizedBox(width: 8),
          Text(
            "VALENTINE_OS",
            style: GoogleFonts.jersey10(
              fontSize: 24,
              color: const Color(0xFF880E4F),
            ),
          ),
          
          const Spacer(),

          // 2. RIGHT: Battery & Mute
          Transform.scale(
            scale: 0.8,
            alignment: Alignment.centerRight,
            child: MuteButton(),
          ),
        ],
      ),
    );
  }
}