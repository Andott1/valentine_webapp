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
      // 2. Preload Graphics (Parallel Loading)
      await Future.wait([
        precacheImage(const AssetImage('assets/bouquet.gif'), context),
        precacheImage(const AssetImage('assets/envelope.png'), context),
        precacheImage(const AssetImage('assets/envelope_open.gif'), context),
        for (int i = 1; i <= 12; i++)
          precacheImage(AssetImage('assets/flowers/$i.png'), context),
      ]);
    }

    // Artificial delay (optional, keeps the retro vibe)
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      // SMART CHECK: Where are we going?
      final target = widget.controller.initialPhase;

      if (target == AppPhase.proposal) {
        // Require button press for audio permission
        setState(() {
          _isLoading = false; 
        });
      } else {
        // Auto-skip for Countdown/Bouquet
        widget.controller.onLoadingComplete();
      }
    }
  }

  void _handleStart() {
    SoundService.playClick();
    widget.controller.onLoadingComplete();
  }

  @override
  Widget build(BuildContext context) {
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
                    "I Have a Question\nFor You...",
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