import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_primary_button.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../../../config/route/routes_name.dart';
import '../../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../../core/utils/constants/icon_path.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppLocalizations.of(context)!.fags,
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
          child: Divider(
            height: 0.5.h,
            thickness: 1,
            color: isDark ? Color(0xffDADADA) : Colors.grey.shade300,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Color(0xff1B3A5C) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Title
              CustomText(
                text: AppLocalizations.of(context)!.fags,

                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textWhite : Color(0xff1D2130),
              ),

              SizedBox(height: 12.h),

              CustomText(
                text: "What does SwimMetrics actually do?",

                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textWhite : Color(0xff1D2130),
              ),
              SizedBox(height: 8.h),
              Text(
                'SwimMetrics provides three unique core tools: ',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? const Color(0xffC7C7C7) : Colors.black54,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),


              SizedBox(height: 10.h),
              CustomDottedText(
                isDark: isDark,
                title:
                    "A Split Calculator that generates projected final times and split patterns from a goal time entered based on real world race-ratio data.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                    "A Converter that transforms swim times between SCY, SCM, and LCM using gender event-specific multipliers.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                    "A Stopwatch that records laps in real time and can convert times in the moment or project finish times depending on the mode.",
              ),
              SizedBox(height: 16.h),
              CustomText(
                text: "How accurate are the predictions and pace projections?",

                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textWhite : Color(0xff1D2130),
              ),
              SizedBox(height: 8.h),
              Text(
                'Predictions use highly detailed ratio tables derived from elite competition data (the Olympics, World Championships, and NCAA Championships). While the projections are mathematically consistent and based on real patterns, they are still estimates — an athlete’s real split distribution may differ due to pacing strategy, fatigue, stroke efficiency, or race conditions.',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? const Color(0xffC7C7C7) : Colors.black54,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),


              SizedBox(height: 16.h),

              CustomText(
                text:
                    "Is SwimMetrics suitable for coaches, swimmers, or parents?",

                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textWhite : Color(0xff1D2130),
              ),
              SizedBox(height: 8.h),
              Text(
                'Yes — all three.',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? const Color(0xffC7C7C7) : Colors.black54,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),


              SizedBox(height: 10.h),
              CustomDottedText(
                isDark: isDark,
                title:
                    "Coaches can create pace charts, race plans, set clear goals for athletes, and so much more!",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                    "Swimmers can learn how to execute races smarter by utilizing the Split Calculator and communicating with their coach on how to meet their goals.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                    "Parents can quickly follow along with races using the Stopwatch predictor during races.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                    "Parents please consult your Swimmer’s Coach before utilizing, implementing, and suggesting race strategies with your Swimmer.",
              ),
              SizedBox(height: 16.h),
              CustomText(
                text: "Can I export my splits or projections?",

                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textWhite : Color(0xff1D2130),
              ),
              SizedBox(height: 8.h),
              Text(
                'Yes. All SwimMetrics tools include Export to PDF functionality. Exports use clean formatting with column balancing so events print neatly. You’ll receive both an HTML file and a fully formatted PDF.',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? const Color(0xffC7C7C7) : Colors.black54,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),


              SizedBox(height: 10.h),

              Text(
                'Use them as pace charts for clear goals to be reached! BB cut, Age Group State Championships, Summer Juniors finalists, Olympic Trials qualifier, World Record, or whatever goal you are trying to reach, this is the tool for you!',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? const Color(0xffC7C7C7) : Colors.black54,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),


              SizedBox(height: 16.h),

              CustomText(
                text:
                    "How does the Real-Time Stopwatch integrate with prediction or conversion?",

                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textWhite : Color(0xff1D2130),
              ),
              SizedBox(height: 8.h),
              Text(
                'The Stopwatch mode has 3 features:',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? const Color(0xffC7C7C7) : Colors.black54,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),


              SizedBox(height: 10.h),
              CustomDottedText(
                isDark: isDark,
                title:
                    "Stopwatch mode → Regular stopwatch. Start, stop, split, and clear that track splits and overall time.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                    "Predictor mode → Each time you press Split, SwimMetrics estimates the final time using your current pace and ratio patterns.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                    "Converter mode → Each Split shows the live time in the starting course AND the converted time for the target course. No more guessing pace if warming up Short Course Yards and then racing Long Course Meters.",
              ),

              SizedBox(height: 16.h),

              CustomText(
                text:
                    "What is the difference between “From Start” and “From Push” in Predictor mode?",

                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textWhite : Color(0xff1D2130),
              ),
              SizedBox(height: 10.h),
              CustomDottedText(
                isDark: isDark,
                title:
                    "“From Start” assumes a standard race start (reaction + dive).",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                    "“From Push” assumes the swimmer begins in the water (like mid-set in training).",
              ),
              SizedBox(height: 10.h),
              Text(
                'The app adjusts the opening split to account for the faster first split when pushing off instead of diving.',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? const Color(0xffC7C7C7) : Colors.black54,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),



              SizedBox(height: 10.h),

              CustomText(
                text:
                    "Why are split options different across courses and distances?",

                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textWhite : Color(0xff1D2130),
              ),
              SizedBox(height: 6.h),
              Text(
                'Each pool type has its own natural increments:',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? const Color(0xffC7C7C7) : Colors.black54,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 10.h),

              CustomDottedText(
                isDark: isDark,
                title: "SCY/SCM → frequently split in 25s",
              ),
              CustomDottedText(
                isDark: isDark,
                title: "LCM → splits are naturally in 50s",
              ),
              SizedBox(height: 10.h),
              Text(
                'Longer events follow 50-meter increments, while shorter races (50/100) have special handling to match real splitting conventions and predictions.',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? const Color(0xffC7C7C7) : Colors.black54,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),




              SizedBox(height: 16.h),

              CustomText(
                text:
                "How are times converted between courses?",

                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textWhite : Color(0xff1D2130),
              ),
              SizedBox(height: 6.h),
              Text(
                'The Converter uses either:',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? const Color(0xffC7C7C7) : Colors.black54,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 10.h),

              CustomDottedText(
                isDark: isDark,
                title: "Direct ratio-based conversions for distances with known elite baseline times",
              ),
              CustomDottedText(
                isDark: isDark,
                title: "Fallback universal conversion factors for simple course-to-course changes",
              ),
              SizedBox(height: 10.h),
              Text(
                'Each conversion is consistent, reproducible, and grounded in stroke-specific and gender-specific reference times',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? const Color(0xffC7C7C7) : Colors.black54,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),




              SizedBox(height: 16.h),

              CustomText(
                text:
                "Why do some distances map to different distances when converting between courses?",

                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textWhite : Color(0xff1D2130),
              ),
              SizedBox(height: 6.h),
              Text(
                'Some events don’t exist in every course type. For example:',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? const Color(0xffC7C7C7) : Colors.black54,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 10.h),

              CustomDottedText(
                isDark: isDark,
                title: "500 SCY → converts to 400 SCM/LCM",
              ),
              CustomDottedText(
                isDark: isDark,
                title: "1000 SCY → converts to 800 SCM/LCM",
              ),
              CustomDottedText(
                isDark: isDark,
                title: "1650 SCY → converts to 1500 SCM/LCM",
              ),
              SizedBox(height: 10.h),
              Text(
                'This is intentional and uses baseline elite reference times to calculate accurate conversion factors.',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? const Color(0xffC7C7C7) : Colors.black54,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),




              SizedBox(height: 16.h),

              CustomText(
                text:
                "Why are some strokes or distances unavailable for certain ratios?",

                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textWhite : Color(0xff1D2130),
              ),
              SizedBox(height: 6.h),
              Text(
                'If a stroke-distance-course combination doesn’t exist in major competitions (i.e. 100 IM LCM) or lacks standardized ratios, SwimMetrics uses safe fallback logic or disables unsupported combinations to avoid misleading projections.',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? const Color(0xffC7C7C7) : Colors.black54,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),


              SizedBox(height: 24.h),

              /// Support Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? Color(0xff032B46) : Color(0xffF1F1F1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Still have questions?",

                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textWhite : Color(0xff1D2130),
                    ),

                    SizedBox(height: 10.h),

                    CustomText(
                      text:
                          "Can’t find the answer you’re looking for? "
                          "Please send your query in support.",

                      color: isDark ? Color(0xffC7C7C7) : Colors.black54,
                    ),

                    SizedBox(height: 24.h),
                    SizedBox(
                      width: 120.w,
                      child: CustomPrimaryButton(
                        title: "Get in touch",
                        onPressed: () {
                          context.push(RouteNames.helpSupportScreen);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget faqItem(String question, String answer, isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 22.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: question,

            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textWhite : Color(0xff1D2130),
          ),

          SizedBox(height: 8.h),

          CustomText(
            text: answer,

            fontSize: 14.sp,
            color: isDark ? Color(0xffC7C7C7) : Colors.black54,
          ),
        ],
      ),
    );
  }
}

class CustomDottedText extends StatelessWidget {
  const CustomDottedText({
    super.key,
    required this.isDark,
    required this.title,
  });

  final bool isDark;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6.h), // align with first line
          width: 4.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xffC7C7C7) : Colors.black54,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? const Color(0xffC7C7C7) : Colors.black54,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
