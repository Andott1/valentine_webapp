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
  final int _totalSlots = 10; 
  final int _charLimit = 60;
  
  int _currentPage = 0;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _plans = StorageService.futurePlans;
  }

  Future<void> _saveAsPng() async {
    try {
      RenderRepaintBoundary? boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      // 1. Capture Image
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      
      Uint8List pngBytes = byteData.buffer.asUint8List();

      // 2. Still trigger the file download (for backup/Android users)
      await FileSaver.instance.saveFile(
        name: "Bucket_List_Page_${_currentPage + 1}",
        bytes: pngBytes,
        fileExtension: "png",
        mimeType: MimeType.png,
      );

      if (mounted) {
        // 3. NEW: Show the "iOS Friendly" Preview Dialog
        _showImagePreview(pngBytes);
      }

    } catch (e) {
      debugPrint("Save Error: $e");
    }
  }

  // --- NEW: PREVIEW DIALOG FOR EASY SAVING ---
  void _showImagePreview(Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.pink, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "Long Press Image to Save <3",
                    style: GoogleFonts.jersey10(fontSize: 24, color: Colors.pink),
                  ),
                  const SizedBox(height: 10),
                  // Display the captured image so she can Long Press -> Save to Photos
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PixelButton(
              text: "CLOSE",
              onPressed: () => Navigator.pop(context),
              mainColor: Colors.white,
              shadowColor: Colors.grey,
              highlightColor: Colors.white70,
            )
          ],
        ),
      ),
    );
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
                  if (controller.text.isEmpty) {
                     _plans.removeAt(absoluteIndex);
                  } else {
                     _plans[absoluteIndex] = controller.text;
                  }
                } else {
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
        
        const double topBarBuffer = 100.0; 
        final double effectiveMaxHeight = (constraints.maxHeight - topBarBuffer);
        final double boardHeight = effectiveMaxHeight * 0.75;
        const double headerHeight = 170.0; 
        const double itemHeight = 70.0;
        
        final double availableForItems = boardHeight - headerHeight;
        final int itemsPerPage = (availableForItems / itemHeight).floor().clamp(2, 5);
        
        final int totalPages = (_totalSlots / itemsPerPage).ceil();

        if (_currentPage >= totalPages) _currentPage = totalPages - 1;
        if (_currentPage < 0) _currentPage = 0;

        final int startIndex = _currentPage * itemsPerPage;
        final int endIndex = min(startIndex + itemsPerPage, _totalSlots);

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
                      // HEADER - SCALED
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "OUR BUCKET LIST",
                          style: GoogleFonts.jersey10(
                            fontSize: (screenWidth < 600) ? 36 : 48, 
                            color: const Color(0xFFD81B60)
                          ),
                          textAlign: TextAlign.center,
                        ),
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
              text: "SAVE PAGE",
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