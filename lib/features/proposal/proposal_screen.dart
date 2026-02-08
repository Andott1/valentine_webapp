import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_controller.dart';
import '../../core/ui/falling_hearts_background.dart';
import '../../core/ui/pixel_button.dart';
import '../../core/services/sound_service.dart';
import '../../core/ui/flower_explosion.dart';
import '../../core/ui/typewriter_text.dart'; // Ensure this is imported

class ProposalScreen extends StatefulWidget {
  final AppController controller;

  const ProposalScreen({super.key, required this.controller});

  @override
  State<ProposalScreen> createState() => _ProposalScreenState();
}

class _ProposalScreenState extends State<ProposalScreen> {
  bool _isNoLocked = false;
  bool _showExplosion = false;
  bool _showButtons = false; // Buttons are hidden until typing ends

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
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2A1D23),
        content: Text(
          "Nice try! That button is broken now. Try the other one <3",
          style: GoogleFonts.jersey10(
            fontSize: 24,
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
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Fixed height container to prevent layout jump
                        SizedBox(
                          height: 140, 
                          child: Center(
                            child: TypewriterText(
                              text: "Will you be my\nValentine?",
                              // Slightly slower for dramatic effect
                              speed: const Duration(milliseconds: 150), 
                              onComplete: () {
                                setState(() {
                                  _showButtons = true;
                                });
                              },
                              style: GoogleFonts.jersey10(
                                fontSize: 64, 
                                height: 1.0, 
                                color: const Color(0xFFC2185B), 
                                shadows: [
                                  const Shadow(offset: Offset(3, 3), color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 60),
                        
                        // Fade in the buttons ONLY after typing is done
                        AnimatedOpacity(
                          opacity: _showButtons ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 1000),
                          child: Column(
                            children: [
                              PixelButton(
                                text: "YES <3",
                                onPressed: _showButtons ? _handleYesClick : null, 
                              ),
                              
                              const SizedBox(height: 24),
                              
                              PixelButton(
                                text: _isNoLocked ? "LOCKED" : "NO",
                                isLocked: _isNoLocked,
                                onPressed: _showButtons ? _handleNoClick : null,
                                mainColor: const Color(0xFF4DD0E1),      
                                shadowColor: const Color(0xFF0097A7),    
                                highlightColor: const Color(0xFFB2EBF2), 
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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