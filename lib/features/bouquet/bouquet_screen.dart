import 'package:flutter/material.dart';
import '../../app_controller.dart';
import '../../core/ui/falling_flowers_background.dart';
import '../../core/ui/mute_button.dart';
import '../notes/future_plans_board.dart';
import '../../core/services/sound_service.dart';

class BouquetScreen extends StatefulWidget {
  final AppController controller;

  const BouquetScreen({super.key, required this.controller});

  @override
  State<BouquetScreen> createState() => _BouquetScreenState();
}

class _BouquetScreenState extends State<BouquetScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _scaleAnimation;
  
  // Controller for the page scrolling
  final PageController _pageController = PageController();

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
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. The Main Content (Background + PageView)
          FallingFlowersBackground(
             child: PageView(
               controller: _pageController,
               scrollDirection: Axis.vertical,
               children: [
                 // PAGE 1: Bouquet
                 Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Happy Valentine's Day! Baby <3", textAlign: TextAlign.center, style: TextStyle(fontSize: 40, color: Color(0xFFD81B60), fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.white, offset: Offset(2, 2))])),
                      const SizedBox(height: 40),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.white.withValues(alpha: 0.6), blurRadius: 50, spreadRadius: 10)]),
                          child: Image.asset('assets/bouquet.gif', width: 300, fit: BoxFit.contain, filterQuality: FilterQuality.none),
                        ),
                      ),
                      const SizedBox(height: 60),
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

          // 2. THE MUTE BUTTON (Top Right Corner)
          const Positioned(
            top: 40,
            right: 20,
            child: SafeArea(
              child: MuteButton(),
            ),
          ),
        ],
      ),
    );
  }
}