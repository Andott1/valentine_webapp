import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SpritePlayer extends StatefulWidget {
  final String assetPath;
  final int frameCount;
  final double frameWidth; // The visual width of ONE frame
  final Duration duration;
  final bool loop;

  const SpritePlayer({
    super.key,
    required this.assetPath,
    required this.frameCount,
    required this.frameWidth,
    this.duration = const Duration(milliseconds: 1000),
    this.loop = false,
  });

  @override
  State<SpritePlayer> createState() => _SpritePlayerState();
}

class _SpritePlayerState extends State<SpritePlayer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _frameAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Creates a step animation: 0, 1, 2, 3...
    _frameAnimation = IntTween(begin: 0, end: widget.frameCount - 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    if (widget.loop) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _frameAnimation,
      builder: (context, child) {
        // Calculate how much to shift the image left
        // If we are on frame 2, shift left by (2 * width)
        double offset = -1 * _frameAnimation.value * widget.frameWidth;

        return SizedBox(
          width: widget.frameWidth, // Only show ONE frame's width
          height: widget.frameWidth, // Assuming square frames
          child: ClipRect(
            child: Stack(
              children: [
                Positioned(
                  left: offset,
                  top: 0,
                  // The Inner SVG is Width * Count long
                  child: SvgPicture.asset(
                    widget.assetPath,
                    width: widget.frameWidth * widget.frameCount,
                    height: widget.frameWidth,
                    fit: BoxFit.fill, // Ensure it stretches correctly
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}