import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_controller.dart'; // Import Controller
import '../../core/services/date_service.dart';
import '../../core/ui/falling_flowers_background.dart';
import '../../core/ui/pixel_window.dart';

class CountdownScreen extends StatefulWidget {
  final AppController controller; // Add Field

  const CountdownScreen({super.key, required this.controller}); // Update Constructor

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

  // --- NEW: PASSWORD DIALOG LOGIC ---
  void _showDebugLogin() {
    final TextEditingController passController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF0F5),
        shape: BeveledRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 3),
            borderRadius: BorderRadius.circular(10)),
        title: Text("ADMIN OVERRIDE",
            style: GoogleFonts.jersey10(fontSize: 32, color: Colors.red)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Enter password to skip time:",
                style: GoogleFonts.jersey10(fontSize: 20)),
            const SizedBox(height: 10),
            TextField(
              controller: passController,
              obscureText: true,
              style: GoogleFonts.jersey10(fontSize: 24),
              decoration: InputDecoration(
                hintText: "Password...",
                hintStyle: GoogleFonts.jersey10(color: Colors.grey),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.pink, width: 2)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("CANCEL", style: GoogleFonts.jersey10(fontSize: 24, color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              // --- PASSWORD CHECK ---
              if (passController.text == "waitforvalentines") {
                Navigator.pop(context); // Close dialog
                widget.controller.debugTestBouquet(); // TRIGGER SKIP
              } else {
                // Shake/Error feedback could go here, for now just close
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("ACCESS DENIED", style: GoogleFonts.jersey10(color: Colors.white, fontSize: 20)),
                  )
                );
              }
            },
            child: Text("UNLOCK", style: GoogleFonts.jersey10(fontSize: 24, color: Colors.red)),
          ),
        ],
      ),
    );
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
      body: Stack( // Changed to Stack to overlay the button
        children: [
          FallingFlowersBackground(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Builder(
                    builder: (context) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      double windowWidth;
                      if (screenWidth < 600) {
                        windowWidth = screenWidth * 0.9;
                      } else {
                        windowWidth = min(screenWidth * 0.5, 800);
                      }

                      return SizedBox(
                        width: windowWidth,
                        child: PixelWindow(
                          title: "Invitation_Status.exe",
                          color: const Color(0xFFB2DFDB),
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
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCFD8DC),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: const Color(0xFF546E7A), width: 3),
                                  boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, 0))]
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Text("$days", style: GoogleFonts.jersey10(fontSize: 56, color: const Color(0xFF37474F), height: 1.0)),
                                        const SizedBox(width: 8),
                                        Text("DAYS", style: GoogleFonts.jersey10(fontSize: 24, color: const Color(0xFF78909C))),
                                      ],
                                    ),
                                    Container(margin: const EdgeInsets.symmetric(vertical: 8), height: 2, color: const Color(0xFFB0BEC5)),
                                    Text("${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}", style: GoogleFonts.jersey10(fontSize: 48, color: const Color(0xFF37474F), letterSpacing: 4, height: 1.0)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 25),
                              Text("See you in February 14!.", style: GoogleFonts.jersey10(fontSize: 20, color: Colors.black87)),
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

          // --- NEW DEBUG BUTTON LOCATION ---
          Positioned(
            right: 20, 
            bottom: 20,
            child: SafeArea(
              child: Opacity(
                opacity: 0.3, // Subtle
                child: IconButton(
                  icon: const Icon(Icons.key, size: 30, color: Colors.black), 
                  tooltip: "Developer Override (Password Required)",
                  onPressed: _showDebugLogin,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}