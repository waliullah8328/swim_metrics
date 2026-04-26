import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../../core/utils/constants/icon_path.dart';


import '../../../../../../l10n/app_localizations.dart';
import '../../faq/presentation/screen/faq_screen.dart';

class IdeaForUseScreen extends StatelessWidget {
  const IdeaForUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          text: AppLocalizations.of(context)!.ideasForUse,
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
                "1. Outcome‑Driven Pace Charts",
                fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w800,
              ),
              CustomText(
                  text:
                  "Instead of building pace charts around abstract times, SwimMetrics generates pace charts tied directly to competitive outcomes:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "Earning a BB Time Standard",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Making Finals",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Earning Sectionals or Futures Time Standard",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Enter any time you think can help you make your goals a reality",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Each goal becomes its own pacing blueprint, grounded in elite split ratios.",
              ),

              SizedBox(height: 10.h),
              CustomText(
                text:
                "2. “What If” Race Simulation Tool",
                fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w800,
              ),
              CustomText(
                  text:
                  "Use SwimMetrics as a race simulator, not just a planner.Swimmers can model:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "Going out too fast vs. too controlled",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Different back-half strategies",
              ),

              CustomDottedText(
                isDark: isDark,
                title:
                "Aggressive vs. conservative first 50 / 100",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "This turns SwimMetrics into a learning sandbox — swimmers experiment with pacing mistakes before they make them in real races.",
              ),



              SizedBox(height: 10.h),
              CustomText(
                text:
                "3. Progression Maps for an Entire Season",
                fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w800,
              ),
              CustomText(
                  text:
                  "Instead of one-off pace charts, coaches can use SwimMetrics to build season-long progression ladders.Example:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "Early season: hold +:02 race pace",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Mid season: hold +:01 race pace",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Championship season: hold goal splits",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Each phase is generated from the same elite-based ratios.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "SwimMetrics becomes a periodization tool, not just the day of a meet.",
              ),



              SizedBox(height: 10.h),
              CustomText(
                text:
                "4. Benchmarking “Swim IQ” (Not Just Speed)",
                fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w800,
              ),
              CustomText(
                  text:
                  "SwimMetrics can be used to evaluate pacing intelligence, not just raw performance.Compare:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h,),

              CustomDottedText(
                isDark: isDark,
                title:
                "Actual race splits",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "SwimMetrics projected splits",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Deviation patterns",
              ),



              SizedBox(height: 10.h),
              CustomText(
                text:
                "Over time, swimmers learn:",
                fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w800,
              ),

              SizedBox(height: 4.h),
              CustomText(
                text:
                "“I always die on the 3rd 50”",
                fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w500,
              ),

              SizedBox(height: 4.h),
              CustomText(
                text:
                "“I over-swim the first length in fly”",
                fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w500,
              ),

              SizedBox(height: 4.h),
              CustomText(
                text:
                "“My back-half pacing is elite even if my speed isn’t”",
                fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 10.h),

              CustomText(
                  text:
                  "SwimMetrics brings together analytics, timing, pacing, and projections—so swimmers can understand their races like never before.Stop guessing, start analyzing.",
                  fontSize: 13.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 10.h,),
              CustomText(
                  text:
                  "SwimMetrics is a race execution evaluator and helps make swimmers and coaches smarter.",
                  fontSize: 13.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomText(
                  text:
                  "It’s everything you need in one place, with no fluff or guesswork.",
                  fontSize: 13.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 10.h),
              CustomText(
                text:
                "5. Meet Warm‑Up & Readiness Tool",
                fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w800,
              ),
              CustomText(
                  text:
                  "Use SwimMetrics before the race even starts.Coaches can:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h,),

              CustomDottedText(
                isDark: isDark,
                title:
                "Convert last season’s best time to today’s swimmer's new goals to generate expected splits",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Use those splits to set warm up pace expectations",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "SwimMetrics becomes a readiness diagnostic, not a post-race tool.",
              ),

              SizedBox(height: 10.h),
              CustomText(
                text:
                "6. Parent Education Mode",
                fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w800,
              ),
              CustomText(
                  text:
                  "Parents can use SwimMetrics to:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h,),

              CustomDottedText(
                isDark: isDark,
                title:
                "Understand why a swimmer was off pace",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "See how early splits affect the finish",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Stop judging races only by final time",
              ),
              SizedBox(height: 10.h,),
              CustomText(
                  text:
                  "SwimMetrics becomes a translation layer between coaches and parents.Parents please consult your Swimmer’s Coach before utilizing, implementing, and suggesting race strategies with your Swimmer.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
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