import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GeneratingScreen extends StatelessWidget {
  const GeneratingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Lottie animation ─────────────────────────
            Lottie.asset(
              'assets/animations/generating_animation.json',
              width: 400,
              height: 400,
              repeat: true,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 24),

            // ── Label ────────────────────────────────────
            const Text(
              'Generating your story...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'This may take a few seconds',
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
