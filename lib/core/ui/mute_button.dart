import 'package:flutter/material.dart';
import '../services/sound_service.dart';

class MuteButton extends StatefulWidget {
  const MuteButton({super.key});

  @override
  State<MuteButton> createState() => _MuteButtonState();
}

class _MuteButtonState extends State<MuteButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SoundService.toggleMute();
        setState(() {}); // Rebuild to change icon
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F5), // Light Cyan (Retro Windows color)
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
             BoxShadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 0)
          ]
        ),
        child: Icon(
          SoundService.isMuted ? Icons.music_off : Icons.music_note,
          color: const Color(0xFF006064), // Dark Cyan text
          size: 20,
        ),
      ),
    );
  }
}