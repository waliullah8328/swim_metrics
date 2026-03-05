import 'package:flutter/material.dart';

class AppSnackBar {
  /// Show an error SnackBar

  static void showError(BuildContext context, String message, {String title = 'Error'}) {
    _showSnackBar(
      context,
      title,
      message,
      backgroundColor: const Color(0xffDC143C),
      icon: Icons.error_outline,
    );
  }

  /// Show a success SnackBar
  static void showSuccess(BuildContext context, String message, {String title = 'Success'}) {
    _showSnackBar(
      context,
      title,
      message,
      backgroundColor: Colors.green.shade700,
      icon: Icons.check_circle_outline,
    );
  }

  /// Core reusable Snackbar builder
  static void _showSnackBar(
      BuildContext context,
      String title,
      String message, {
        required Color backgroundColor,
        required IconData icon,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
