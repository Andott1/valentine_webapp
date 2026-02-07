import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import '../../app_controller.dart';
import '../../core/ui/falling_flowers_background.dart';
import '../../core/ui/mute_button.dart';
import '../../core/ui/flip_widget.dart';
import '../../core/ui/floating_widget.dart';
import '../notes/future_plans_board.dart';
import '../../core/services/sound_service.dart';
import 'love_letter_window.dart';

class BouquetScreen extends StatefulWidget {
  final AppController controller;

  const BouquetScreen({super.key, required this.controller});

  @override
  State<BouquetScreen> createState() => _BouquetScreenState();
}

class _BouquetScreenState extends State<BouquetScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _scaleAnimation;
  late AnimationController _flipController;

  final PageController _pageController = PageController();
  
  // STATE MANAGEMENT
  bool _isEnvelopeVisible = false; // Is the back side showing?
  bool _isOpening = false;         // Is the GIF playing?

  @override
  void initState() {
    super.initState();
    SoundService.playBgm();
    
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.elasticOut,
    );

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    if (widget.controller.shouldPlayTransformation) {
      _entranceController.forward();
    } else {
      _entranceController.value = 1.0;
    }
  }

  @override
  void dispose() {
    SoundService.stopBgm();
    _entranceController.dispose();
    _flipController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // --- INTERACTION LOGIC ---

  void _toggleFlip() {
    // If we are currently playing the opening animation, ignore taps
    if (_isOpening) return;

    SoundService.playClick();
    
    if (_isEnvelopeVisible) {
      // Flip back to Bouquet
      _flipController.reverse();
      setState(() => _isEnvelopeVisible = false);
    } else {
      // Flip to Envelope
      _flipController.forward();
      setState(() => _isEnvelopeVisible = true);
    }
  }

  void _handleSwipeUp(DragEndDetails details) {
    // 1. Must be looking at envelope
    // 2. Must not already be opening
    // 3. Must be a distinct UPWARD swipe (negative velocity)
    if (_isEnvelopeVisible && !_isOpening && details.primaryVelocity! < -500) {
      _playOpeningSequence();
    }
  }

  void _playOpeningSequence() async {
    
    // 1. CRITICAL FIX: Evict the GIF from the cache.
    // This forces Flutter to forget the "looping" state and reload it from Frame 0.
    await const AssetImage('assets/envelope_open.gif').evict();

    if (!mounted) return;

    setState(() {
      _isOpening = true; // Now shows the fresh GIF starting at 0:00
    });

    SoundService.playClick(); // Or your paper sound

    // 2. Timer matches your GIF length (You mentioned 4000ms)
    Timer(const Duration(milliseconds: 4400), () {
      if (mounted) {
        // Reset state so it shows the closed envelope again when we return
        setState(() => _isOpening = false); 
        
        // 3. Launch the Letter with the smooth Slide Down animation
        _showLetterWindow();
      }
    });
  }

  void _showLetterWindow() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss Letter",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 800), // Smooth drop speed
      pageBuilder: (context, animation, secondaryAnimation) {
        return const LoveLetterWindow();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Slide from Top (-1.0) to Center (0.0) with a bounce/ease feel
        final curvedValue = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuart, 
        );
        
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1), // Starts above screen
            end: Offset.zero,
          ).animate(curvedValue),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FallingFlowersBackground(
             child: PageView(
               controller: _pageController,
               scrollDirection: Axis.vertical,
               physics: _isOpening ? const NeverScrollableScrollPhysics() : null, // Lock scroll during animation
               children: [
                 // PAGE 1: Bouquet / Envelope
                 Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Happy Valentine's Day!\nILYSM Baby <3", 
                        textAlign: TextAlign.center, 
                        style: TextStyle(
                          fontSize: 40, 
                          color: Color(0xFFD81B60), 
                          fontWeight: FontWeight.bold, 
                          shadows: [Shadow(color: Colors.white, offset: Offset(2, 2))]
                        )
                      ),
                      const SizedBox(height: 20),
                      
                      // THE INTERACTIVE WIDGET
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: GestureDetector(
                          onTap: _toggleFlip, // Tap always toggles
                          onVerticalDragEnd: _handleSwipeUp, // Swipe Up opens
                          child: FloatingWidget(
                            child: FlipWidget(
                              controller: _flipController,
                              
                              // FRONT: The Bouquet
                              front: _buildAssetContainer('assets/Bouquet.gif'),
                              
                              // BACK: The Envelope (Static OR Opening GIF)
                              back: _isOpening 
                                  ? _buildAssetContainer('assets/envelope_open.gif') // The Animation
                                  : _buildAssetContainer('assets/envelope.png'),     // The Static Closed
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      Text(
                        _isEnvelopeVisible 
                           ? "(Swipe Up to Open)" 
                           : "(Tap for a surprise)", 
                        style: const TextStyle(fontSize: 16, color: Colors.black26)
                      ),
                      
                      const SizedBox(height: 40),
                      const Icon(Icons.keyboard_arrow_down, size: 40, color: Colors.black26),
                      const Text("Scroll Down", style: TextStyle(fontSize: 16, color: Colors.black26)),
                    ],
                  ),
                 ),
                 
                 // PAGE 2: Future Plans
                 const Center(
                   child: SingleChildScrollView(
                     child: Padding(
                       padding: EdgeInsets.symmetric(vertical: 40),
                       child: FuturePlansBoard(),
                     ),
                   ),
                 ),
               ],
             ),
          ),
          
          const Positioned(
            top: 40,
            right: 20,
            child: SafeArea(child: MuteButton()),
          ),
        ],
      ),
    );
  }

  // Helper to keep code clean
  Widget _buildAssetContainer(String assetPath) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle, 
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.6), 
            blurRadius: 50, 
            spreadRadius: 10
          )
        ]
      ),
      child: Image.asset(
        assetPath,
        width: 300, 
        fit: BoxFit.contain, 
        filterQuality: FilterQuality.none,
        gaplessPlayback: true, // Prevents flickering when switching GIF/PNG
      ),
    );
  }
}