import 'package:flutter/material.dart';
import '../../app_controller.dart';
import '../../core/ui/falling_flowers_background.dart';
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
      // Background stays persistent behind the scrolling pages
      body: FallingFlowersBackground(
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.vertical, // SCROLLS UP/DOWN LIKE A FEED
          children: [
            // --- PAGE 1: THE REVEAL ---
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Happy Valentine's Day!\n ILYSM Baby <3",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      color: Color(0xFFD81B60),
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.white, offset: Offset(2, 2))]
                    ),
                  ),
                  const SizedBox(height: 20),
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.6),
                            blurRadius: 50,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/Bouquet.gif',
                        width: 300,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Hint arrow to tell them to scroll down
                  const Icon(Icons.keyboard_arrow_down, size: 40, color: Colors.black26),
                  const Text(
                    "Scroll Down",
                    style: TextStyle(fontSize: 16, color: Colors.black26),
                  ),
                ],
              ),
            ),

            // --- PAGE 2: THE FUTURE PLANS ---
            const Center(
              child: SingleChildScrollView( // Kept in case notes overflow on small screens
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: FuturePlansBoard(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}