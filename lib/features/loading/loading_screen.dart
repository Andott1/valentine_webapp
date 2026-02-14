import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_controller.dart';
import '../../core/models/app_phase.dart';
import '../../core/services/sound_service.dart';
import '../../core/ui/pixel_button.dart';

class LoadingScreen extends StatefulWidget {
  final AppController controller;

  const LoadingScreen({super.key, required this.controller});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    // 1. Preload Audio
    await SoundService.preload();

    if (mounted) {
      // 2. Preload Graphics
      await Future.wait([
        precacheImage(const AssetImage('assets/Bouquet.gif'), context), // Capital B
        precacheImage(const AssetImage('assets/envelope.png'), context),
        precacheImage(const AssetImage('assets/envelope_open.gif'), context),
        for (int i = 1; i <= 12; i++)
          precacheImage(AssetImage('assets/flowers/$i.png'), context),
      ]);
    }

    // Artificial delay for effect
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      // --- FIX: REMOVE AUTO-SKIP ---
      // We ALWAYS show the button now. This ensures the user MUST click
      // "Proceed", which gives us the "User Interaction" required to 
      // play audio on iOS/Web after a reload.
      setState(() {
        _isLoading = false; 
      });
    }
  }

  void _handleStart() {
    // 1. Play Click
    SoundService.playClick();
    
    // 2. START BGM HERE
    // Since we are inside a button click callback, the browser 
    // gives us full permission to play audio.
    if (widget.controller.initialPhase != AppPhase.proposal) {
       SoundService.playBgm(); 
    }

    // 3. Navigate
    widget.controller.onLoadingComplete();
  }

  @override
  Widget build(BuildContext context) {
    // Customize text based on where we are going
    final String startText = (widget.controller.initialPhase == AppPhase.proposal)
        ? "I Have a Question\nFor You..."
        : "Welcome Back\nBabyy <3";

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading) ...[
                // Loading Text
                FittedBox( 
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "LOADING...",
                    style: GoogleFonts.jersey10(
                      fontSize: 48,
                      color: const Color(0xFF880E4F),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: Color(0xFFF48FB1),
                    strokeWidth: 4,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Initializing Heart.exe...",
                  style: GoogleFonts.jersey10(fontSize: 20, color: Colors.black45),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                // Start Screen
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    startText, // Dynamic Text
                    style: GoogleFonts.jersey10(
                      fontSize: 48,
                      color: const Color(0xFFD81B60),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                PixelButton(
                  text: "Proceed",
                  onPressed: _handleStart,
                  mainColor: const Color(0xFF4FC3F7),
                  shadowColor: const Color(0xFF0288D1),
                  highlightColor: const Color(0xFF81D4FA),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}