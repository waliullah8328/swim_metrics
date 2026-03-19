import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../../core/utils/constants/icon_path.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../faq/presentation/screen/faq_screen.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          text: AppLocalizations.of(context)!.termsAndConditions,
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

              /// Date
               Center(
                child: CustomText(text:
                  "Effective Date: March 16, 2026",

                    color: isDark?Color(0xff2DA8F0):Color(0xff5BA9C7),
                    fontSize: 14.sp,
                  fontWeight: FontWeight.w600,

                ),
              ),

               SizedBox(height: 10.h),

              /// Title
             Center(
                child: CustomText(text:
                  "TERMS AND CONDITIONS OF USE",

                    fontSize: 20.sp,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,

                ),
              ),

               SizedBox(height: 6.h),

              CustomText(
                text:
                "Operated by: PMcC Solutions LLC, a Texas limited liability company (“PMcC Solutions,” “Company,” “we,” “us,” or “our”) ",
               fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                text:
                "These Terms and Conditions of Use (“Agreement”) govern your access to and use of the SwimMetrics mobile application, including all calculations, tools, features, content, and related services (collectively, the “App” or “Services”).",
               fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "By downloading, installing, accessing, or using SwimMetrics, you acknowledge that you have read, understood, and agree to be bound by this Agreement and the SwimMetrics Privacy Policy.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "If you do not agree, you must immediately discontinue use and uninstall the App.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

             SizedBox(height: 10.h),
              Divider(),
              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "1. Purpose of SwimMetrics",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "SwimMetrics provides race-split calculations, pacing projections, course conversions, timing tools, and related performance-analysis features for swimmers and coaches.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "The App is provided solely for informational and training-support purposes. It is not a substitute for professional coaching, certified instruction, medical advice, therapeutic guidance, or safety supervision.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "All calculations, ratios, pacing models, and projections are estimates only and are not affiliated with or endorsed by any governing body.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Unauthorized reproduction, redistribution, reverse engineering, data extraction, or competitive analysis using SwimMetrics’ content is strictly prohibited.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 10.h,),
              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "2. No Duty of Care",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Use of SwimMetrics does not create any duty of care, professional relationship, fiduciary relationship, coaching relationship, or medical relationship between you and PMcC Solutions. PMcC Solutions owes no duty to monitor, supervise, verify, or correct any training decisions, athletic activities, or reliance on App outputs.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 10.h,),
              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "3. Eligibility and Age Requirements",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "SwimMetrics is intended for users thirteen (13) years of age or older.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "If you are a minor, you may use the App only under the supervision of a parent, legal guardian, or coach, who agrees to be bound by this Agreement and is responsible for all use, exported files, and shared data involving minors. SwimMetrics is not directed to children under the age of thirteen (13) and is not intended for use by children without supervision as described herein.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "You represent that you have the legal capacity to enter into this Agreement. ",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 10.h,),
              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "4. Minors and Parental Responsibility",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "By permitting a minor to use SwimMetrics, the parent, legal guardian, or supervising coach acknowledges and agrees that athletic training involves inherent risks and voluntarily assumes all risks associated with the minor’s use of the App. By permitting a minor to download, install, or use the App on any device under your control, you affirmatively consent to this Agreement on the minor’s behalf.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "PMcC Solutions disclaims any responsibility for supervision, instruction, or safety of minors. ",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "To the extent permitted by applicable law, this Agreement does not purport to waive, release, or limit any rights or claims of a minor that cannot legally be waived on the minor’s behalf. Any provisions relating to assumption of risk, release, indemnification, or limitation of liability apply only to the maximum extent enforceable under applicable law and do not invalidate the remainder of this Agreement. ",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 10.h,),
              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "5. Subscription, Billing, and Payments (If Applicable)",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Certain features of SwimMetrics may require a paid subscription.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "All subscriptions, renewals, cancellations, and payments are processed exclusively through Apple App Store or Google Play, depending on your device.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Subscriptions renew automatically unless canceled at least 24 hours before the renewal date.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Prices may change in accordance with App Store and Google Play policies and without advance notice.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Canceling a subscription stops future charges but does not refund prior payments.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "PMcC Solutions does not issue refunds. Refund requests must be directed to Apple or Google under their respective policies.",
              ),

              SizedBox(height: 10.h,),
              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "6. License Grant",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Subject to your compliance with this Agreement, PMcC Solutions grants you a limited, non-exclusive, non-transferable, non-sublicensable, revocable license to install and use the App solely for personal, non-commercial use.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "No rights are granted except those expressly stated herein.",
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