import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PixelWindow extends StatefulWidget {
  final Widget child;
  final String title;
  final Color color;

  const PixelWindow({
    super.key,
    required this.child,
    this.title = "",
    this.color = const Color(0xFFB2DFDB),
  });

  @override
  State<PixelWindow> createState() => _PixelWindowState();
}

class _PixelWindowState extends State<PixelWindow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Moves up and down by 6 pixels
    _floatAnimation = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Colors for the 3D Bevel Effect
    final Color highlight = Colors.white.withValues(alpha: 0.9);
    final Color shadow = Colors.black.withValues(alpha: 0.4);
    final Color borderColor = Colors.black;

    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: child,
        );
      },
      child: Container(
        // Outer Black Border
        decoration: BoxDecoration(
          color: widget.color,
          border: Border.all(color: borderColor, width: 3),
          // Hard Retro Shadow (No Blur)
          boxShadow: const [
            BoxShadow(color: Colors.black26, offset: Offset(8, 8), blurRadius: 0),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- TITLE BAR ---
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.color,
                // Inner 3D Highlight for Title Bar
                border: Border(
                  top: BorderSide(color: highlight, width: 2),
                  left: BorderSide(color: highlight, width: 2),
                  right: BorderSide(color: shadow, width: 2),
                  bottom: BorderSide(color: borderColor, width: 3),
                ),
              ),
              child: Row(
                children: [
                  // Title
                  Text(
                    widget.title,
                    style: GoogleFonts.jersey10(
                      fontSize: 20,
                      color: Colors.black87,
                      height: 1.0,
                    ),
                  ),
                  const Spacer(),
                  // Retro Buttons
                  _buildPixelButton(Colors.white), // Minimize
                  const SizedBox(width: 4),
                  _buildPixelButton(Colors.white), // Maximize
                  const SizedBox(width: 4),
                  _buildPixelButton(const Color(0xFFFF8A80), isClose: true), // Close
                ],
              ),
            ),

            // --- CONTENT AREA ---
            Container(
              padding: const EdgeInsets.all(4), // Frame spacing
              decoration: BoxDecoration(
                color: widget.color,
                border: Border(
                  left: BorderSide(color: highlight, width: 2),
                  right: BorderSide(color: shadow, width: 2),
                  bottom: BorderSide(color: shadow, width: 2),
                ),
              ),
              child: Container(
                // The actual white content box
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: shadow, width: 2), // Inset shadow
                    left: BorderSide(color: shadow, width: 2),
                    right: BorderSide(color: highlight, width: 2),
                    bottom: BorderSide(color: highlight, width: 2),
                  ),
                ),
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for the tiny window buttons (Minimize, Maximize, Close)
  Widget _buildPixelButton(Color color, {bool isClose = false}) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
           BoxShadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 0)
        ]
      ),
      child: isClose
          ? const Center(
              child: Icon(Icons.close, size: 14, color: Colors.black),
            )
          : null, // Basic boxes for min/max
    );
  }
}