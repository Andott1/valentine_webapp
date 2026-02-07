import 'dart:async';
import 'dart:math'; // Import for min/max logic
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/date_service.dart';
import '../../core/ui/falling_flowers_background.dart';
import '../../core/ui/pixel_window.dart'; // Ensure you have the updated PixelWindow from previous step

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      _timeLeft = DateService.timeUntilValentines();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    int days = _timeLeft.inDays;
    int hours = _timeLeft.inHours % 24;
    int minutes = _timeLeft.inMinutes % 60;
    int seconds = _timeLeft.inSeconds % 60;

    return Scaffold(
      body: FallingFlowersBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Builder(
                builder: (context) {
                  // RESPONSIVE SIZING LOGIC
                  final screenWidth = MediaQuery.of(context).size.width;
                  double windowWidth;

                  if (screenWidth < 600) {
                    // Mobile: Take up 90% of the screen
                    windowWidth = screenWidth * 0.9;
                  } else {
                    // PC/Tablet: Take 50% as requested, but max out at 800px
                    // to prevent it from looking stretched on ultra-wide monitors.
                    windowWidth = min(screenWidth * 0.5, 800);
                  }

                  return SizedBox(
                    width: windowWidth,
                    child: PixelWindow(
                      title: "Invitation_Status.exe",
                      color: const Color(0xFFB2DFDB), // Mint Green
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "INVITATION ACCEPTED!",
                            style: GoogleFonts.jersey10(
                              fontSize: 42,
                              color: const Color(0xFFD81B60),
                              height: 1.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 10),
                          
                          Text(
                            "Please return to this site in:",
                            style: GoogleFonts.jersey10(
                              fontSize: 24,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 25),
                          
                          // THE TIMER (Grayish LCD)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCFD8DC), // Blue-Grey LCD
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFF546E7A), width: 3),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, offset: Offset(0, 0))
                              ]
                            ),
                            child: Column(
                              children: [
                                // DAYS
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      "$days",
                                      style: GoogleFonts.jersey10(
                                        fontSize: 56, 
                                        color: const Color(0xFF37474F), 
                                        height: 1.0
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "DAYS",
                                      style: GoogleFonts.jersey10(
                                        fontSize: 24, 
                                        color: const Color(0xFF78909C)
                                      ),
                                    ),
                                  ],
                                ),
                                
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  height: 2,
                                  color: const Color(0xFFB0BEC5),
                                ),

                                // TIME
                                Text(
                                  "${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}",
                                  style: GoogleFonts.jersey10(
                                    fontSize: 48, 
                                    color: const Color(0xFF37474F), 
                                    letterSpacing: 4, 
                                    height: 1.0
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 25),

                          Text(
                            "See you in February 14!.",
                            style: GoogleFonts.jersey10(
                              fontSize: 20, 
                              color: Colors.black87
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}