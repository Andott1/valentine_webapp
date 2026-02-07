import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_controller.dart';
import '../../core/services/sound_service.dart';
import '../../core/ui/pixel_button.dart'; // Reuse your button!

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
      await precacheImage(const AssetImage('assets/bouquet.gif'), context);
      // Preload the flower/heart images if needed
      for(int i=1; i<=12; i++) {
        await precacheImage(AssetImage('assets/flowers/$i.png'), context);
      }
    }

    // Artificial delay to let the "Loading" text breathe
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      setState(() {
        _isLoading = false; // Show the "Start" button
      });
    }
  }

  void _handleStart() {
    // 3. PLAY SOUND ON FIRST INTERACTION
    // This critical step unlocks the AudioContext for the whole app.
    SoundService.playClick();
    
    // 4. Enter the App
    widget.controller.onLoadingComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOADING PHASE
            if (_isLoading) ...[
              Text(
                "LOADING...",
                style: GoogleFonts.jersey10(
                  fontSize: 48,
                  color: const Color(0xFF880E4F),
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
                style: GoogleFonts.jersey10(
                  fontSize: 20,
                  color: Colors.black45,
                ),
              ),
            ] 
            // READY PHASE ("Title Screen")
            else ...[
              Text(
                "I have a question for you...",
                style: GoogleFonts.jersey10(
                  fontSize: 48,
                  color: const Color(0xFFD81B60),
                ),
              ),
              const SizedBox(height: 40),
              
              // Blinking "Press Start" effect or just a button
              PixelButton(
                text: "Proceed",
                onPressed: _handleStart,
                mainColor: const Color(0xFF4FC3F7), // Retro Blue
                shadowColor: const Color(0xFF0288D1),
                highlightColor: const Color(0xFF81D4FA),
              ),
            ],
          ],
        ),
      ),
    );
  }
}