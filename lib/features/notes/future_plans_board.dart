import 'dart:math'; // Import for min()
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/storage_service.dart';
import '../../core/ui/pixel_window.dart'; // IMPORT PIXEL WINDOW

class FuturePlansBoard extends StatefulWidget {
  const FuturePlansBoard({super.key});

  @override
  State<FuturePlansBoard> createState() => _FuturePlansBoardState();
}

class _FuturePlansBoardState extends State<FuturePlansBoard> {
  List<String> _plans = [];
  final int _maxPlans = 5;
  final int _charLimit = 60;

  @override
  void initState() {
    super.initState();
    _plans = StorageService.futurePlans;
  }

  void _addOrEditPlan(int index) {
    TextEditingController controller = TextEditingController();
    if (index < _plans.length) {
      controller.text = _plans[index];
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF0F5),
        shape: BeveledRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 3),
            borderRadius: BorderRadius.circular(10)),
        title: Text("Future Plan #${index + 1}",
            style: GoogleFonts.jersey10(fontSize: 32)),
        content: TextField(
          controller: controller,
          maxLength: _charLimit,
          style: GoogleFonts.jersey10(fontSize: 24),
          decoration: InputDecoration(
            hintText: "E.g., Buy a house...",
            hintStyle: GoogleFonts.jersey10(color: Colors.grey),
            counterStyle: GoogleFonts.jersey10(fontSize: 16),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("CANCEL",
                style: GoogleFonts.jersey10(fontSize: 24, color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (index < _plans.length) {
                  // Edit existing
                  if (controller.text.isEmpty) {
                     _plans.removeAt(index);
                  } else {
                     _plans[index] = controller.text;
                  }
                } else {
                  // Add new
                  if (controller.text.isNotEmpty) _plans.add(controller.text);
                }
                StorageService.setFuturePlans(_plans);
              });
              Navigator.pop(context);
            },
            child: Text("SAVE",
                style: GoogleFonts.jersey10(fontSize: 24, color: Colors.pink)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // RESPONSIVE SIZING LOGIC
    final screenWidth = MediaQuery.of(context).size.width;
    double containerWidth;

    if (screenWidth < 600) {
      // Mobile: 90% width
      containerWidth = screenWidth * 0.9;
    } else {
      // Desktop: 50% width (capped at 800px)
      containerWidth = min(screenWidth * 0.5, 800);
    }

    return Center(
      child: SizedBox(
        width: containerWidth,
        // WRAPPED IN PIXEL WINDOW
        child: PixelWindow(
          title: "Future_Plans.exe",
          color: const Color(0xFFF8BBD0), // Pastel Pink to match the theme
          child: Column(
            children: [
              Text(
                "OUR BUCKET LIST",
                style: GoogleFonts.jersey10(fontSize: 48, color: const Color(0xFFD81B60)),
                textAlign: TextAlign.center,
              ),
              Text(
                "Let's save up for these!",
                style: GoogleFonts.jersey10(fontSize: 20, color: const Color(0xFF880E4F)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              
              // THE 5 SLOTS
              ...List.generate(_maxPlans, (index) {
                bool isFilled = index < _plans.length;
                return GestureDetector(
                  onTap: () => _addOrEditPlan(index),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    decoration: BoxDecoration(
                      // Clean white look inside the slots
                      color: isFilled ? const Color(0xFFF8BBD0) : Colors.grey[100],
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, offset: Offset(2, 2))
                      ]
                    ),
                    child: Row(
                      children: [
                        Text(
                          "${index + 1}.",
                          style: GoogleFonts.jersey10(fontSize: 24, color: Colors.black54),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isFilled ? _plans[index] : "Empty Slot (Tap to add)",
                            style: GoogleFonts.jersey10(
                              fontSize: 24,
                              color: isFilled ? Colors.black : Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isFilled) const Icon(Icons.edit, size: 16, color: Colors.black45)
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}