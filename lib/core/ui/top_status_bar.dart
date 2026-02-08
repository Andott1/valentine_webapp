import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mute_button.dart';

class TopStatusBar extends StatelessWidget {
  const TopStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
  return Container(
    constraints: const BoxConstraints(
      minHeight: 60,
      maxHeight: 80,
    ),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // 👈 Important
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              "VALENTINE_OS",
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.jersey10(
                fontSize: 28,
                color: const Color(0xFF880E4F),
              ),
            ),
          ],
        ),

        const MuteButton(), // 👈 Automatically right aligned
      ],
    ),
  );
}
}