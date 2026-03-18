import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showGlassSnackbar(
  BuildContext context,
  String message,
  String lottieAsset, {
  bool repeat = false,
  VoidCallback? onDismiss, // ← add this
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    lottieAsset,
                    width: 160,
                    height: 160,
                    repeat: repeat,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onDismiss?.call(); // ← fires after OK is tapped
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Color(0xFFFF7643),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}