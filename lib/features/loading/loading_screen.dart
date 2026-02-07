import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_controller.dart';
import '../../core/services/sound_service.dart';

class LoadingScreen extends StatefulWidget {
  final AppController controller;

  const LoadingScreen({super.key, required this.controller});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    // 1. Preload Audio
    await SoundService.preload();

    if (mounted) {
      // 2. Preload The Heavy GIF
      // precacheImage decodes it immediately so it doesn't pop in late
      await precacheImage(const AssetImage('assets/bouquet.gif'), context);
      
      // 3. Optional: Preload a few flowers if you want extra smoothness
      // (Not strictly necessary as they are small, but good for safety)
      await precacheImage(const AssetImage('assets/flowers/1.png'), context);
    }

    // 4. Artificial small delay just to make sure UI settles (optional)
    await Future.delayed(const Duration(milliseconds: 500));

    // 5. Tell Controller we are done
    if (mounted) {
      widget.controller.onLoadingComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5), // Lavender Blush
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Retro Loading Spinner (Just text blinking or static for now)
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
          ],
        ),
      ),
    );
  }
}