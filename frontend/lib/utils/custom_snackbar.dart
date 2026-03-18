import 'package:flutter/material.dart';

enum SnackbarType { error, success, warning }

void showCustomSnackbar(
  BuildContext context,
  String message, {
  SnackbarType type = SnackbarType.error,
}) {
  Color bgColor;
  IconData icon;

  switch (type) {
    case SnackbarType.error:
      bgColor = const Color(0xFFD32F2F);
      icon = Icons.error_outline;
      break;
    case SnackbarType.success:
      bgColor = const Color(0xFF388E3C);
      icon = Icons.check_circle_outline;
      break;
    case SnackbarType.warning:
      bgColor = const Color(0xFFF57C00);
      icon = Icons.warning_amber_outlined;
      break;
  }

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}