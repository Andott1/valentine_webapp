import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_controller.dart';
import 'features/proposal/proposal_screen.dart';
import 'features/bouquet/bouquet_screen.dart';
import 'core/models/app_phase.dart';
import 'features/countdown/countdown_screen.dart';
import 'features/loading/loading_screen.dart';
import 'core/ui/crt_overlay.dart';

class ValentineApp extends StatefulWidget {
  const ValentineApp({super.key});

  @override
  State<ValentineApp> createState() => _ValentineAppState();
}

class _ValentineAppState extends State<ValentineApp> {
  final controller = AppController();

  @override
  void initState() {
    super.initState();
    controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFF48FB1),
        scaffoldBackgroundColor: const Color(0xFFFFF0F5),
        textTheme: GoogleFonts.jersey10TextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: const Color(0xFF880E4F),
          displayColor: const Color(0xFF880E4F),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const BeveledRectangleBorder(),
            backgroundColor: const Color(0xFFF06292),
            foregroundColor: Colors.white,
            elevation: 8,
            textStyle: GoogleFonts.jersey10(fontSize: 24),
          ),
        ),
      ),
      home: ValueListenableBuilder(
        valueListenable: controller.phaseNotifier,
        builder: (context, AppPhase phase, _) {
          return CrtOverlay(
            child: Builder(
              builder: (context) {
                switch (phase) {
                  case AppPhase.loading:
                    return LoadingScreen(controller: controller);
                  case AppPhase.proposal:
                    return ProposalScreen(controller: controller);
                  case AppPhase.countdown:
                    // UPDATE THIS LINE: Pass the controller
                    return CountdownScreen(controller: controller); 
                  case AppPhase.bouquet:
                    return BouquetScreen(controller: controller);
                }
              },
            ),
          );
        },
      ),
    );
  }
}