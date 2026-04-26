import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../../core/utils/constants/icon_path.dart';
import '../../../../../../../l10n/app_localizations.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor = isDark ? const Color(0xff2DA8F0) : const Color(0xff5BA9C7);
    final textColor = isDark ? const Color(0xffC7C7C7) : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppLocalizations.of(context)!.termsAndConditions,
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => context.pop(),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 0.5.h,
            thickness: 1,
            color: isDark ? const Color(0xffDADADA) : Colors.grey.shade300,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff1B3A5C) : Colors.white,
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
              // Header Section
              Center(
                child: CustomText(
                  text: "Effective Date: March 16, 2026",
                  color: secondaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: CustomText(
                  text: "TERMS AND CONDITIONS AND PRIVACY POLICY OF USE",
                  fontSize: 20.sp,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              CustomText(
                text: "Operated by: PMcC Solutions LLC, a Texas limited liability company (PMcC Solutions)",
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: "These Terms and Conditions of Use (“Agreement”) govern your access to and use of the SwimMetrics mobile application, including all calculations, tools, features, content, and related services (collectively, the “App” or “Services”).\n\nBy downloading, installing, accessing, or using SwimMetrics, you acknowledge that you have read, understood, and agree to be bound by this Agreement and the SwimMetrics Privacy Policy.\n\nIf you do not agree, you must immediately discontinue use and uninstall the App.",
                fontSize: 14.sp,
                color: textColor,
              ),

              const Divider(height: 32),

              _buildSection("1. Purpose of SwimMetrics",
                  "SwimMetrics provides race-split calculations, pacing projections, course conversions, timing tools, and related performance-analysis features for swimmers and coaches.\n\nThe App is provided solely for informational and training-support purposes. It is not a substitute for professional coaching, certified instruction, medical advice, therapeutic guidance, or safety supervision.\n\nAll calculations, ratios, pacing models, and projections are estimates only and are not affiliated with or endorsed by any governing body.\n\nUnauthorized reproduction, redistribution, reverse engineering, data extraction, or competitive analysis using SwimMetrics’ content is strictly prohibited.",
                  textColor),

              _buildSection("2. No Duty of Care",
                  "Use of SwimMetrics does not create any duty of care, professional relationship, fiduciary relationship, coaching relationship, or medical relationship between you and the Company. We do not owe duty to monitor, supervise, verify, or correct any training decisions, athletic activities, or reliance on App outputs.",
                  textColor),

              _buildSection("3. Eligibility and Age Requirements",
                  "SwimMetrics is intended for users thirteen (13) years of age or older.\n\nIf you are a minor, you may use the App only under the supervision of a parent, legal guardian, or coach, who agrees to be bound by this Agreement and is responsible for all use, exported files, and shared data involving minors. SwimMetrics is not directed to children under the age of thirteen (13) and is not intended for use by children without supervision as described herein.\n\nYou represent that you have the legal capacity to enter into this Agreement.",
                  textColor),

              _buildSection("4. Minors and Parental Responsibility",
                  "By permitting a minor to use SwimMetrics, the parent, legal guardian, or supervising coach acknowledges and agrees that athletic training involves inherent risks and voluntarily assumes all risks associated with the minor’s use of the App. By permitting a minor to download, install, or use the App on any device under your control, you affirmatively consent to this Agreement on the minor’s behalf.\n\nWe disclaim any responsibility for supervision, instruction, or safety of minors.\n\nTo the extent permitted by applicable law, this Agreement does not purport to waive, release, or limit any rights or claims of a minor that cannot legally be waived on the minor’s behalf.",
                  textColor),

              _buildSection("5. Subscription, Billing, and Payments",
                  "All subscriptions, renewals, cancellations, and payments are processed exclusively through Apple App Store or Google Play. Subscriptions renew automatically unless canceled at least 24 hours before the renewal date. We do not issue refunds. Refund requests must be directed to Apple or Google.",
                  textColor),

              _buildSection("6. License Grant",
                  "We grant you a limited, non-exclusive, non-transferable, non-sublicensable, revocable license to install and use the App solely for personal, non-commercial use.",
                  textColor),

              _buildSection("7. User Responsibilities",
                  "You agree to use SwimMetrics safely and responsibly. You acknowledge that you exercise independent judgment in all training, pacing, and performance decisions and that you do not rely on SwimMetrics as the sole or primary basis for any athletic, health, or safety decision.",
                  textColor),

              _buildSection("8. User Control",
                  "You acknowledge that you control all training variables, including intensity, duration, rest, and participation, and that the Company does not monitor, enforce, or limit any physical activity.",
                  textColor),

              _buildSection("9. Prohibited Uses and Restrictions",
                  "You agree not to reverse engineer, decompile, disassemble, or attempt to extract source code, algorithms, or proprietary logic. Any prohibited use immediately terminates your license.",
                  textColor),

              _buildSection("10. Ownership and Intellectual Property",
                  "The App and all related intellectual property—including algorithms, pacing ratios, and UI/UX—are the exclusive property of the Company.",
                  textColor),

              _buildSection("11. Data Handling and Privacy",
                  "SwimMetrics operates without collecting, storing, or processing personal information on external servers. All data is processed locally on your device. In the event of any conflict between these Terms and the Privacy Policy regarding data handling, the Privacy Policy controls.",
                  textColor),

              _buildSection("12. No Coaching, Medical, or Performance Guarantees",
                  "The App provides computational tools only. YOU EXPRESSLY AND VOLUNTARILY ASSUME ALL RISKS ASSOCIATED WITH USE OF THE APP, RELIANCE ON APP OUTPUTS, AND PARTICIPATION IN ANY ATHLETIC ACTIVITIES.",
                  textColor),

              _buildSection("13. Software-Only Product",
                  "The Company disclaims any liability under theories of product liability or strict liability to the fullest extent permitted by law.",
                  textColor),

              _buildSection("14. Disclaimer of Warranties",
                  "THE APP IS PROVIDED “AS IS” WITHOUT WARRANTIES OF ANY KIND, EXPRESS, IMPLIED, OR STATUTORY.",
                  textColor),

              _buildSection("15. Limitation of Liability",
                  "To the maximum extent permitted by law, the Company shall not be liable for indirect, incidental, or consequential damages, including bodily injury or death.",
                  textColor),

              _buildSection("16. Release of Claims (Texas Law)",
                  "This release expressly includes claims based on the ordinary negligence of the Company and its affiliates, to the fullest extent permitted by Texas law.",
                  textColor),

              _buildSection("17. Indemnification",
                  "You agree to indemnify and hold harmless the Company from any claims arising from your use or misuse of the App.",
                  textColor),

              _buildSection("18. Termination",
                  "We may suspend or terminate your access at any time for violation of this Agreement.",
                  textColor),

              _buildSection("19. Governing Law",
                  "This Agreement is governed by the laws of the State of Texas.",
                  textColor),

              _buildSection("20. Mandatory Arbitration",
                  "Any dispute shall be resolved exclusively through binding arbitration in Travis County, Texas. You waive any right to a jury trial or class action. Opt-out via contact@swimmetricsapp.com within 30 days.",
                  textColor),

              _buildSection("21. Assignment", "We may assign this Agreement without restriction."),

              _buildSection("22. Force Majeure", "Neither party is liable for failures caused by events beyond reasonable control."),

              _buildSection("23. Severability", "If any provision is found unenforceable, the remaining provisions remain in effect."),

              _buildSection("24. Entire Agreement and Updates",
                  "This Agreement and Privacy Policy supersede all prior agreements. Continued use constitutes acceptance of updates.\n\nApple App Store/Google Play Terms: These platforms are third-party beneficiaries but are not responsible for the App content or support.",
                  textColor),

              _buildSection("25. Notices",
                  "Notices shall be sent to: contact@swimmetricsapp.com",
                  textColor),

              SizedBox(height: 20.h),
              //const Divider(),
              SizedBox(height: 10.h),
              Center(
                child: CustomText(
                  text: "For questions, contact:\ncontact@swimmetricsapp.com",
                  textAlign: TextAlign.center,
                  fontSize: 14.sp,
                  color: textColor,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, [Color? textColor]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        CustomText(
          text: title,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 6.h),
        CustomText(
          text: content,
          fontSize: 14.sp,
          color: textColor,
        ),
        SizedBox(height: 8.h),
        const Divider(),
      ],
    );
  }
}