import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Make sure this is imported
import '../../app_controller.dart';
import '../../core/ui/falling_hearts_background.dart';
import '../../core/ui/pixel_button.dart';
import '../../core/services/sound_service.dart';
import '../../core/ui/flower_explosion.dart'; 

class ProposalScreen extends StatefulWidget {
  final AppController controller;

  const ProposalScreen({super.key, required this.controller});

  @override
  State<ProposalScreen> createState() => _ProposalScreenState();
}

class _ProposalScreenState extends State<ProposalScreen> {
  bool _isNoLocked = false;
  bool _showExplosion = false; 

  void _handleYesClick() {
    SoundService.playSuccess();
    widget.controller.acceptProposal();
    setState(() {
      _showExplosion = true;
    });
  }

  void _handleNoClick() {
    if (_isNoLocked) return;
    SoundService.playError();
    setState(() {
      _isNoLocked = true;
    });
    
    // --- UPDATED SNACKBAR ---
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2A1D23),
        content: Text(
          "Nice try! That button is broken now. Try the other one <3",
          style: GoogleFonts.jersey10( // <--- FONT FIX
            fontSize: 24, // Readable size for pixel font
            color: Colors.white,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FallingHeartsBackground(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFF0F5).withValues(alpha: 0.9), // Lavender Blush
                    const Color(0xFFFFCDD2).withValues(alpha: 0.5)  // Light Red/Pink
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Will you be my\nValentine?", 
                      textAlign: TextAlign.center, 
                      style: GoogleFonts.jersey10(
                        fontSize: 64, 
                        height: 1.0, 
                        color: const Color(0xFFC2185B), // Pink Darker
                        shadows: [
                          const Shadow(offset: Offset(3, 3), color: Colors.white),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    
                    PixelButton(
                      text: "YES <3",
                      onPressed: _handleYesClick, 
                    ),
                    
                    const SizedBox(height: 24),
                    
                    PixelButton(
                      text: _isNoLocked ? "LOCKED" : "NO",
                      isLocked: _isNoLocked,
                      onPressed: _handleNoClick,
                      // PASTEL TEAL/BLUE VARIANT for "NO"
                      mainColor: const Color(0xFF4DD0E1),      // Cyan/Teal
                      shadowColor: const Color(0xFF0097A7),    // Dark Cyan
                      highlightColor: const Color(0xFFB2EBF2), // Light Cyan
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          Positioned(
            right: 20, bottom: 40,
            child: SafeArea(
              child: Opacity(
                opacity: 0.6, 
                child: IconButton(
                  icon: const Icon(Icons.bug_report, size: 30, color: Colors.black45), 
                  onPressed: widget.controller.debugTestBouquet
                )
              ),
            ),
          ),

          if (_showExplosion)
            Positioned.fill(
              child: FlowerExplosion(
                onComplete: () {
                  widget.controller.transitionAfterProposal();
                },
              ),
            ),
        ],
      ),
    );
  }
}