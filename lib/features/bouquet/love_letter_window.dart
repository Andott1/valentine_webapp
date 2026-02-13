import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/ui/pixel_window.dart';

class LoveLetterWindow extends StatelessWidget {
  const LoveLetterWindow({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Calculate a dynamic max height (e.g., 60% of the screen)
    // This ensures the window never grows taller than the screen.
    final double maxContentHeight = MediaQuery.of(context).size.height * 0.6;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: PixelWindow(
        title: "Love_Letter.txt",
        color: const Color(0xFFFFCDD2), // Light Red/Pink
        // 2. Wrap content in a constrained Container
        child: Container(
          constraints: BoxConstraints(
            maxHeight: maxContentHeight, // Enforce the limit
            minHeight: 100, // Prevent it from being too squashed
          ),
          // 3. The ScrollView now operates strictly within those constraints
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // THE LETTER
                Text(
                  "Dear Jaja,\n\n"
                  "Happy Valentine's Day!! I love you so much babyy "
                  "it's our 6th year mag valentines hehe or 7th hmmm I can't remember if we celebrated during 2019 but anyways, "
                  "Thank you for staying by my side baby especially in times that I'm struggling (like rn) "
                  "and sorry if i don't have real flowers for you :( so as substitute i created this web app for you <3 "
                  "I hope you like it baby! Hopefully we can celebrate special occasions like this properly again soon. "
                  "There's a bucket list section below so you can list down what you want us to do soon! "
                  "Click SAVE PAGE for each page and send it to me okie. \n\n"
                  "I'll always do my best to make you feel loved and important baby, I LOVE YOU SO MUCH\n\n"
                  "Love,\nAndot",
                  style: GoogleFonts.jersey10(
                    fontSize: 24,
                    color: const Color(0xFF880E4F),
                    height: 1.2,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}