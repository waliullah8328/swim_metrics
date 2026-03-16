import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';
import 'package:swim_metrics/feature/on_boarding/presentation/screens/widget/wheel_selector_widget.dart' hide LanguageWheelSelector;

import '../../../../../config/language/language.dart';
import '../../../../home_section/calculator_section/setting_section/settings/riverpod/setting_controller.dart';
import '../../riverpod/on_boarding_view_model.dart';
import 'language_wheel_selector.dart';

class LanguagePage extends ConsumerWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 32.w,right: 32.w),
          child: Row(

            children: [
              SvgPicture.asset(IconPath.languageIcon),
              SizedBox(width: 10.w,),
              CustomText(text: "Select Your Language",fontSize: 22.sp,fontWeight: FontWeight.w600,color: AppColors.textWhite,)

            ],
          ),
        ),
        SizedBox(height: 24.h),

        LanguageWheelSelector(
          items: AppLanguage.values,
          selectedLanguage: settings.language,
          onChanged: (AppLanguage lang) async {
            // Save selection in Riverpod + SharedPreferences
            await controller.changeLanguage(lang);

            if (kDebugMode) {
              print('Selected language: ${ref.read(settingsProvider).language.name}');
            }
          },
        )

      ],
    );
  }
}
