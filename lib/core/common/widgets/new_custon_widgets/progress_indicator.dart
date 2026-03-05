import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

/// Show a modal progress indicator (non-dismissible)
Future<void> showProgressIndicator(BuildContext context) async {
  await Future.delayed(const Duration(milliseconds: 50)); // smoother render

  if (ModalRoute.of(context)?.isCurrent != true) return;

  // Prevent multiple dialogs
  if (Navigator.of(context, rootNavigator: true).canPop()) return;

  showDialog(
    context: context,
    barrierDismissible: false,
    useSafeArea: false,
    builder: (_) => Center(
      child: SpinKitFadingCircle(
        color: AppColors.primary,
        size: getWidth(50),
      ),
    ),
  );
}

/// Hide the progress indicator if visible
Future<void> hideProgressIndicator(BuildContext context) async {
  await Future.delayed(const Duration(milliseconds: 100));

  if (Navigator.of(context, rootNavigator: true).canPop()) {
    try {
      Navigator.of(context, rootNavigator: true).pop();
    } catch (_) {
      // Already closed or context invalid
    }
  }
}

