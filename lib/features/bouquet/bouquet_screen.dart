import 'dart:async';
import 'package:flutter/material.dart';
import '../../app_controller.dart';
import '../../core/ui/falling_flowers_background.dart';
import '../../core/ui/top_status_bar.dart'; 
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
  bool _isEnvelopeVisible = false;
  bool _isOpening = false;

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

  void _toggleFlip() {
    if (_isOpening) return;
    SoundService.playClick();
    if (_isEnvelopeVisible) {
      _flipController.reverse();
      setState(() => _isEnvelopeVisible = false);
    } else {
      _flipController.forward();
      setState(() => _isEnvelopeVisible = true);
    }
  }

  void _handleOpenLetter() {
    if (_isEnvelopeVisible && !_isOpening) {
      _playOpeningSequence();
    }
  }

  void _playOpeningSequence() async {
    await const AssetImage('assets/envelope_open.gif').evict();
    if (!mounted) return;
    setState(() => _isOpening = true);
    SoundService.playClick();

    Timer(const Duration(milliseconds: 6200), () {
      if (mounted) {
        setState(() => _isOpening = false);
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
      transitionDuration: const Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) => const LoveLetterWindow(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = CurvedAnimation(parent: animation, curve: Curves.easeOutQuart);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(curvedValue),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    final double bouquetSize = (screenWidth * 0.8).clamp(200.0, 350.0);
    final double constrainedSize = (bouquetSize > screenHeight * 0.45) 
        ? screenHeight * 0.45 
        : bouquetSize;

    return Scaffold(
      body: Stack(
        children: [
          FallingFlowersBackground(
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              physics: _isOpening ? const NeverScrollableScrollPhysics() : null,
              children: [
                // PAGE 1: Bouquet Hub
                SafeArea( 
                  child: Column(
                    children: [
                      const SizedBox(height: 60), 
                      
                      const Spacer(flex: 2),

                      // TITLE TEXT
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: FittedBox( 
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Happy Valentine's Day!\nILYSM Baby <3", 
                            textAlign: TextAlign.center, 
                            style: TextStyle(
                              fontSize: 48, 
                              color: const Color(0xFFD81B60), 
                              fontWeight: FontWeight.bold, 
                              shadows: const [Shadow(color: Colors.white, offset: Offset(2, 2))]
                            )
                          ),
                        ),
                      ),
                      
                      const Spacer(flex: 1),
                      
                      // THE BOUQUET WIDGET
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: GestureDetector(
                          onTap: _toggleFlip,
                          onLongPress: _handleOpenLetter, 
                          child: FloatingWidget(
                            child: FlipWidget(
                              controller: _flipController,
                              front: _buildContainer(constrainedSize, child: Image.asset('assets/bouquet.gif', fit: BoxFit.contain, gaplessPlayback: true)),
                              back: _buildContainer(constrainedSize, child: Image.asset(_isOpening ? 'assets/envelope_open.gif' : 'assets/envelope.png', fit: BoxFit.contain, gaplessPlayback: true)),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),

                      // HINT TEXT UPDATED
                      Text(
                        _isEnvelopeVisible ? "(Long Press to Open)" : "(Tap for a surprise)", 
                        style: const TextStyle(fontSize: 20, color: Colors.black45)
                      ),
                      
                      const Spacer(flex: 3), 

                      const Icon(Icons.keyboard_arrow_down, size: 40, color: Colors.black26),
                      const Text("Scroll Down", style: TextStyle(fontSize: 16, color: Colors.black26)),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                
                // PAGE 2: Future Plans
                SafeArea(
                   child: Column( 
                     children: [
                       const Expanded(
                         child: Padding(
                           padding: EdgeInsets.all(20), 
                           child: FuturePlansBoard(),
                         ),
                       ),
                     ],
                   ),
                 ),
              ],
            ),
          ),
          
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: TopStatusBar()
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer(double size, {required Widget child}) {
    return Container(
      width: size,
      height: size, 
      decoration: BoxDecoration(
        shape: BoxShape.circle, 
        boxShadow: [
          BoxShadow(color: Colors.white.withValues(alpha: 0.6), blurRadius: 50, spreadRadius: 10)
        ]
      ),
      child: child,
    );
  }
}