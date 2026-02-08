import 'dart:math'; 
import 'dart:ui' as ui;
import 'dart:typed_data'; 
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_saver/file_saver.dart'; 
import '../../core/services/storage_service.dart';
import '../../core/ui/pixel_window.dart';
import '../../core/ui/pixel_button.dart';

class FuturePlansBoard extends StatefulWidget {
  const FuturePlansBoard({super.key});

  @override
  State<FuturePlansBoard> createState() => _FuturePlansBoardState();
}

class _FuturePlansBoardState extends State<FuturePlansBoard> {
  List<String> _plans = [];
  final int _totalSlots = 10; // Bumped to 10 as requested
  final int _charLimit = 60;
  
  // PAGINATION STATE
  int _currentPage = 0;
  
  // GLOBAL KEY FOR SCREENSHOTS
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _plans = StorageService.futurePlans;
  }

  // --- SAVE LOGIC ---
  Future<void> _saveAsPng() async {
    try {
      RenderRepaintBoundary? boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      
      Uint8List pngBytes = byteData.buffer.asUint8List();

      await FileSaver.instance.saveFile(
        name: "Bucket_List_Page_${_currentPage + 1}",
        bytes: pngBytes,
        fileExtension: "png",
        mimeType: MimeType.png,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF43A047),
            content: Text("Page saved!", style: GoogleFonts.jersey10(fontSize: 24, color: Colors.white)),
            duration: const Duration(seconds: 2),
          )
        );
      }
    } catch (e) {
      debugPrint("Save Error: $e");
    }
  }

  void _addOrEditPlan(int absoluteIndex) {
    TextEditingController controller = TextEditingController();
    if (absoluteIndex < _plans.length) {
      controller.text = _plans[absoluteIndex];
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF0F5),
        shape: BeveledRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 3),
            borderRadius: BorderRadius.circular(10)),
        title: Text("Plan #${absoluteIndex + 1}",
            style: GoogleFonts.jersey10(fontSize: 32)),
        content: TextField(
          controller: controller,
          maxLength: _charLimit,
          style: GoogleFonts.jersey10(fontSize: 24),
          decoration: InputDecoration(
            hintText: "Type here...",
            hintStyle: GoogleFonts.jersey10(color: Colors.grey),
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
                if (absoluteIndex < _plans.length) {
                  // Edit existing
                  if (controller.text.isEmpty) {
                     _plans.removeAt(absoluteIndex);
                  } else {
                     _plans[absoluteIndex] = controller.text;
                  }
                } else {
                  // Add new
                  // Pad with empty strings if adding to a slot far ahead (edge case handling)
                  while (_plans.length < absoluteIndex) {
                    _plans.add(""); 
                  }
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        
        // --- SMART HEIGHT CALCULATION ---
        // 1. Reserve space for the Top Status Bar (80px) + Bottom Padding (20px)
        const double topBarBuffer = 100.0; 
        
        // 2. Calculate the "Real" available height for our board
        // We use 75% of the *remaining* space, not the total screen
        final double effectiveMaxHeight = (constraints.maxHeight - topBarBuffer);
        final double boardHeight = effectiveMaxHeight * 0.75;
        
        // 3. Constants for item calculation
        const double headerHeight = 170.0; // Title + Nav + Padding
        const double itemHeight = 70.0;
        
        // 4. Calculate Items Per Page
        // logic: (BoardHeight - Header) / ItemHeight
        final double availableForItems = boardHeight - headerHeight;
        
        // 5. Clamp logic: Even on tiny screens, show at least 2 items.
        // If screen is HUGE, show max 5.
        final int itemsPerPage = (availableForItems / itemHeight).floor().clamp(2, 5);
        
        // ... (Rest of logic: totalPages, startIndex, etc. remains the same)
        final int totalPages = (_totalSlots / itemsPerPage).ceil();

        if (_currentPage >= totalPages) _currentPage = totalPages - 1;
        if (_currentPage < 0) _currentPage = 0;

        final int startIndex = _currentPage * itemsPerPage;
        final int endIndex = min(startIndex + itemsPerPage, _totalSlots);

        // Width Logic
        double containerWidth;
        if (screenWidth < 600) {
          containerWidth = screenWidth * 0.95;
        } else {
          containerWidth = min(screenWidth * 0.6, 800);
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: _globalKey,
              child: SizedBox(
                width: containerWidth,
                child: PixelWindow(
                  title: "Future_Plans.exe",
                  color: const Color(0xFFF8BBD0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // HEADER
                      Text(
                        "OUR BUCKET LIST",
                        style: GoogleFonts.jersey10(
                          fontSize: (screenWidth < 600) ? 36 : 48, 
                          color: const Color(0xFFD81B60)
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Let's save up for these!",
                        style: GoogleFonts.jersey10(
                          fontSize: (screenWidth < 600) ? 16 : 20, 
                          color: const Color(0xFF880E4F)
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      
                      // DYNAMIC ITEMS
                      ...List.generate(endIndex - startIndex, (i) {
                        int realIndex = startIndex + i;
                        bool isFilled = realIndex < _plans.length;
                        
                        return GestureDetector(
                          onTap: () => _addOrEditPlan(realIndex),
                          child: Container(
                            height: 56, 
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: isFilled ? const Color(0xFFF8BBD0) : Colors.grey[100],
                              border: Border.all(color: Colors.black, width: 2),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, offset: Offset(2, 2))
                              ]
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "${realIndex + 1}.",
                                  style: GoogleFonts.jersey10(fontSize: 24, color: Colors.black54),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    isFilled ? _plans[realIndex] : "Empty Slot",
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

                      const SizedBox(height: 10),
                      
                      // NAVIGATION
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 20),
                            onPressed: _currentPage > 0 
                                ? () => setState(() => _currentPage--) 
                                : null,
                            color: const Color(0xFF880E4F),
                          ),
                          Text(
                            "Page ${_currentPage + 1} of $totalPages",
                            style: GoogleFonts.jersey10(fontSize: 20, color: Colors.black54),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 20),
                            onPressed: _currentPage < totalPages - 1
                                ? () => setState(() => _currentPage++) 
                                : null,
                            color: const Color(0xFF880E4F),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            PixelButton(
              text: "SAVE PAGE AS PNG",
              onPressed: _saveAsPng,
              mainColor: const Color(0xFF81C784),
              shadowColor: const Color(0xFF388E3C),
              highlightColor: const Color(0xFFA5D6A7),
            ),
          ],
        );
      },
    );
  }
}