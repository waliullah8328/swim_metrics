import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../../core/utils/constants/icon_path.dart';


import '../../faq/presentation/screen/faq_screen.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          text: "Summary",
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



              /// Title
              Center(
                child: CustomText(text:
                "SwimMetrics",

                  fontSize: 20.sp,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,

                ),
              ),
              SizedBox(height: 6.h),
              Center(
                child: CustomText(text:
                "The Complete Performance Toolkit for Swimmers & Coaches",

                  fontSize: 16.sp,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,

                ),
              ),

              SizedBox(height: 6.h),

              CustomText(
                  text:
                  "SwimMetrics brings three powerful athlete-focused tools together into one clean, modern app designed to help swimmers train smarter, race faster, and analyze performance. Using unmatched accuracy with data from the Olympics, Short Course World Championships, and NCAA Championships, SwimMetrics data is second to none.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Whether you're an elite athlete chasing precision, a coach managing an entire team, or any athlete with a goal, SwimMetrics is built to elevate every swimmer at every practice.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),


              SizedBox(height: 10.h),
              Divider(),
              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "Three Tools in One App",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w800,
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "1. Advanced Split Calculator",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w800,
              ),
              CustomText(
                  text:
                  "Generate precise race projections using real-world pacing ratios for both genders, every stroke, distance, and course setup (SCY, SCM, LCM).",
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
              CustomText(
                text:
                "2. Time Converter for All Courses (SCY ↔ SCM ↔ LCM)",
                fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w800,
              ),
              CustomText(
                  text:
                  "Convert race times instantly using discipline-accurate conversion logic.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "Detailed split projections for converted times",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Toggle full split breakdowns for precise training targets",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Export conversion results as professional-grade PDFs",
              ),


              SizedBox(height: 10.h),
              CustomText(
                text:
                "3. Fully Integrated Swim Stopwatch With Live Projections",
                fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w800,
              ),
              CustomText(
                  text:
                  "A race-mode stopwatch built specifically for swimming.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "Capture laps with one tap",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Predict final race time in real-time as splits are taken",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Choose “From Start” or “From Push” for accurate pacing",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Stopwatch mode, Predictor mode, and Course Converter mode built in",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Export your timing sheet instantly to a clean, coach-ready PDF",
              ),



              SizedBox(height: 10.h),
              CustomText(
                text:
                "Built for Real Swimming, Not Generic Fitness",
                fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w800,
              ),
              CustomText(
                  text:
                  "SwimMetrics uses stroke-specific, gender-specific, and distance-specific ratios—based on elite-level data—to deliver projections and conversions that swimmers and coaches can trust.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h,),
              CustomText(
                text:
                "Perfect For:",
                fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w800,
              ),

              CustomDottedText(
                isDark: isDark,
                title:
                "Competitive swimmers",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Club, high school, and college coaches",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Training progression and goal setting",
              ),

              SizedBox(height: 10.h),
              CustomText(
                text:
                "Built for Real Swimming, Not Generic Fitness",
                fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w800,
              ),
              CustomText(
                  text:
                  "SwimMetrics uses stroke-specific, gender-specific, and distance-specific ratios—based on elite-level data—to deliver projections and conversions that swimmers and coaches can trust.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 10.h),
              CustomText(
                text:
                "Export Everything",
                fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w800,
              ),
              CustomText(
                  text:
                  "Generate clean HTML and PDF reports ideal for goal sheets and pace charts.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 10.h),
              CustomText(
                text:
                "Train Smarter. Race Faster. Think Like a Coach.",
                fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w800,
              ),
              CustomText(
                  text:
                  "SwimMetrics brings together analytics, timing, pacing, and projections—so swimmers can understand their races like never before.Stop guessing, start analyzing.",
                  fontSize: 13.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomText(
                  text:
                  "SwimMetrics is special. It combines three powerful tools — a split calculator, a course converter, and a real-time stopwatch that predicts the finishing time — into one seamless, professional-grade experience. It uses real elite-level data to generate accurate splits, projections, and time conversions that other apps simply don’t offer. Whether you're a swimmer, coach, or parent, it helps you train smarter, plan better, and understand performance instantly. ",
                  fontSize: 13.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomText(
                  text:
                  "It’s everything you need in one place, with no fluff or guesswork.",
                  fontSize: 13.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),












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