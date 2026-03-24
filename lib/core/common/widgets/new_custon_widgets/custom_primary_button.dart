import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 ADD THIS
import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../../feature/home_section/calculator_section/setting_section/settings/riverpod/setting_controller.dart';

class CustomPrimaryButton extends ConsumerWidget {
  const CustomPrimaryButton({
    super.key,
    required this.title,
    this.onPressed,
    this.isLoading = false,
  });

  final String title;
  final void Function()? onPressed;
  final bool? isLoading;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isHaptic = ref.watch(settingsProvider.select((s)=>s.haptic));
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(double.infinity, 60.h),
      ),
      onPressed: isLoading == true
          ? null
          : () {
        if(isHaptic == true){
          HapticFeedback.lightImpact(); // 👈 HAPTIC HERE

        }

        onPressed?.call();
      },
      child: isLoading!
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: CustomText(
          text: title,
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}