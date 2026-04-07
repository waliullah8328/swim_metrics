import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../../core/utils/constants/icon_path.dart';


import '../../faq/presentation/screen/faq_screen.dart';

class SplitCalculatorScreen extends StatelessWidget {
  const SplitCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          text: "Split Calculator",
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 18.w),
            child: SvgPicture.asset(
              IconPath.backIcon,
              height: 48.h,
              width: 48.w,
              fit: BoxFit.contain,
            ),
          ),
        ),

        /// Divider below AppBar
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 0.5.h, thickness: 1, color: isDark?Color(0xffDADADA):Colors.grey.shade300),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark?Color(0xff1B3A5C):Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomText(
                  text:
                  "Generate precise race projections using real-world pacing ratios for both genders, as well as every stroke, distance, and course (SCY, SCM, LCM).",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "Predict splits from 50s to 1500s",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Smart LCM 50m speed chart modeling",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Automatic pacing curves based on gender, stroke, and course",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Export PDFs for planning and comparing",
              ),

              SizedBox(height: 10.h),













            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: CustomText(text:
      title,

        fontSize: 18.sp,
        fontWeight: FontWeight.bold,

      ),
    );
  }

  Widget sectionText({required bool isDark}) {
    return CustomText(text:
    "Pharetra morbi libero id aliquam elit massa integer tellus. "
        "Quis felis aliquam ullamcorper porttitor. Pulvinar ullamcorper "
        "sit dictumst ut eget a, elementum eu. Maecenas est morbi "
        "mattis id in ac pellentesque ac.",

      fontSize: 14.sp,
      color: isDark?Color(0xffC7C7C7):Colors.black54,

    );
  }
}