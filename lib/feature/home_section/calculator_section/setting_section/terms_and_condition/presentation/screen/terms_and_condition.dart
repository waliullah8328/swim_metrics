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

              SizedBox(height: 10.h,),
              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "7. User Responsibilities",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "You agree to:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomDottedText(
                isDark: isDark,
                title:
                "Use SwimMetrics safely, responsibly, and lawfully.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Not use the App while driving or during activities requiring full attention.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Not rely on the App for emergency, safety-critical, or life-saving purposes.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Ensure the accuracy of all numeric inputs you enter.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Comply with all applicable laws, sport regulations, and organizational requirements.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Assume all risks associated with physical activity, training decisions, and reliance on App outputs.",
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "You acknowledge that you exercise independent judgment in all training, pacing, and performance decisions and that you do not rely on SwimMetrics as the sole or primary basis for any athletic, health, or safety decision. You acknowledge that the App does not replace judgment, experience, supervision, or professional instruction, and that App outputs are only one of many factors you may consider when making training or performance decisions. You acknowledge that SwimMetrics provides computational assistance only and does not make decisions or recommendations on your behalf.",
                  fontSize: 13.sp, color: isDark?Color(0xffC7C7C7):Colors.black87,fontWeight: FontWeight.w400,
              ),

              SizedBox(height: 10.h,),
              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "8. User Control",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "You acknowledge that you control all training variables, including intensity, duration, rest, and participation, and that PMcC Solutions does not monitor, enforce, or limit any physical activity or training decisions.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 10.h,),

              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "9. Prohibited Uses and Restrictions",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "You agree that you will not, directly or indirectly:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "Use the App for unlawful purposes or in violation of any law.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Reverse engineer, decompile, disassemble, decode, or attempt to extract source code, algorithms, pacing ratios, conversion logic, data models, or proprietary logic.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Copy, modify, distribute, translate, adapt, scrape, benchmark, or create derivative works of the App.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Use the App for competitive analysis or to develop or improve competing products or services.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Remove, alter, or obscure proprietary notices or branding",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Interfere with security features or attempt unauthorized access to systems or data.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Upload harmful code, malware, or automated scripts (the App permits numeric input only).",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Misuse exported files, timing logs, or athlete data, including data relating to minors.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Use the App in a manner that violates data-protection or privacy laws.",
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Any prohibited use immediately terminates your license.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 10.h,),

              Divider(),

              SizedBox(height: 10.h),

              CustomText(
                  text:
                  "10. Ownership and Intellectual Property",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "The App and all related intellectual property—including but not limited to:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "software, code, databases, and algorithms",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "pacing ratios, analytics models, and prediction tools",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "conversion logic and timing methodologies",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "UI/UX design, documentation, branding, trademarks, and logos",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "updates, improvements, and derivative works",
              ),
              SizedBox(height: 6.h,),

              CustomText(
                  text:
                  "are the exclusive property of PMcC Solutions LLC and are protected by U.S. and international copyright, trademark, and trade-secret laws. Any feedback or suggestions you provide may be used by PMcC Solutions without compensation or obligation.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              CustomText(
                  text:
                  "You acquire no ownership interest in the App.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 10.h,),

              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "11. Data Handling and Privacy",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "SwimMetrics is designed so that the App’s core functionality operates without collecting, storing, transmitting, synchronizing, or processing personal information on external servers. The App does not require user accounts, and all calculations, timing logs, and projections are processed locally on your device unless you affirmatively choose to export or share them.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "PMcC Solutions does not have access to user-entered data generated through the App’s core functionality. You are solely responsible for securing your device and for the storage, distribution, and lawful use of any exported or shared data.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Communications sent to PMcC Solutions outside the App (such as emails or support inquiries) are not part of the App’s core functionality and may involve personal information voluntarily provided by you for the purpose of responding to inquiries.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Future Features and Data Use:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "PMcC Solutions may, in the future, introduce optional features that require limited collection or processing of user data (such as analytics, cloud synchronization, or account-based functionality). Any such features will be governed by an updated Privacy Policy and, where required by law or platform policy, will be disclosed to users and subject to user consent prior to activation.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "To the extent platform providers, operating systems, or device manufacturers collect data independently of PMcC Solutions, such collection is governed by their respective privacy policies and not by this Agreement.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "In the event of any conflict between these Terms and the Privacy Policy regarding data handling, the Privacy Policy controls.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "User-Generated Outputs:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Any exported files, logs, timing records, or derived outputs are generated solely from user-entered inputs. PMcC Solutions does not verify accuracy, ownership, consent, or lawful use of such outputs and disclaims all liability arising from their sharing, publication, or attribution.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 10.h,),

              Divider(),

              SizedBox(height: 10.h),

              CustomText(
                  text:
                  "12. No Coaching, Medical, or Performance Guarantees",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "SwimMetrics is designed so that the App’s core functionality operates without collecting, storing, transmitting, synchronizing, or processing personal information on external servers. The App does not require user accounts, and all calculations, timing logs, and projections are processed locally on your device unless you affirmatively choose to export or share them.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "The App provides computational tools only and does not provide medical, therapeutic, diagnostic, or certified coaching advice.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "All outputs are estimates and may not reflect actual performance.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "No guarantee is made regarding athletic improvement, race results, or training outcomes.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "You must consult qualified professionals for training, health, and safety decisions.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Consult a physician before beginning any physical activity.",
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "You assume all risks associated with reliance on the App.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Swimming and athletic training involve inherent risks, including injury or death. You voluntarily assume all such risks.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "By using the App, you acknowledge that you are voluntarily participating in athletic training activities with known and unknown risks and that you are solely responsible for assessing your own physical condition and limits.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "For minors, assumption of risk applies only to the extent permitted by applicable law.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "YOU EXPRESSLY AND VOLUNTARILY ASSUME ALL RISKS ASSOCIATED WITH USE OF THE APP, RELIANCE ON APP OUTPUTS, AND PARTICIPATION IN ANY ATHLETIC OR TRAINING ACTIVITIES.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 10.h),

              CustomText(
                  text:
                  "13. Software-Only Product",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "SwimMetrics is a software application that provides informational calculations only and does not constitute sporting equipment, safety equipment, or a physical product. PMcC Solutions disclaims any liability under theories of product liability or strict liability to the fullest extent permitted by law.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 10.h,),

              Divider(),

              SizedBox(height: 10.h),

              CustomText(
                  text:
                  "14. Disclaimer of Warranties",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "THE APP IS PROVIDED “AS IS” AND “AS AVAILABLE”, WITHOUT WARRANTIES OF ANY KIND, EXPRESS, IMPLIED, OR STATUTORY.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "PMcC SOLUTIONS DISCLAIMS ALL WARRANTIES, INCLUDING MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, ACCURACY, RELIABILITY, AND NON-INFRINGEMENT.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "We do not warrant that the App will be uninterrupted, error-free, or meet your specific requirements.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 10.h,),

              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "15. Limitation of Liability",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "TO THE MAXIMUM EXTENT PERMITTED BY LAW:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "PMcC Solutions shall not be liable for indirect, incidental, consequential, punitive, or special damages, including lost profits, lost data, training injuries, athletic outcomes, or reliance on App outputs.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Total aggregate liability shall not exceed the amount you paid for the App or subscription during the twelve (12) months preceding the claim.",
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Some jurisdictions do not allow certain limitations; in those cases, limitations apply to the fullest extent permitted.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "To the fullest extent permitted by applicable law, PMcC Solutions shall have no liability for any bodily injury, illness, disability, or death arising from or related to use of the App, reliance on App outputs, training decisions, or athletic activity, whether such claims are based in contract, tort, negligence, strict liability, or otherwise.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "These limitations apply even if PMcC Solutions has been advised of the possibility of such damages.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "These limitations are a fundamental basis of the bargain between you and PMcC Solutions and shall apply even if any limited remedy fails of its essential purpose.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 10.h,),

              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "16. READ CAREFULLY – RELEASE OF CLAIMS, ASSUMPTION OF RISK, AND RELEASE OF NEGLIGENCE (TEXAS LAW)",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "TO THE FULLEST EXTENT PERMITTED BY LAW, you hereby release, waive, and discharge PMcC Solutions LLC, SwimMetrics, and their members, officers, employees, contractors, and affiliates from any and all claims, demands, causes of action, damages, or liabilities of any kind, whether known or unknown, arising out of or related to:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "Your use of the App",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Reliance on App outputs",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Training, competition, or athletic activity",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "injury, illness, disability, or death.",
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "This release expressly includes, and is intended to release, claims based on the ordinary negligence of PMcC Solutions LLC and its affiliates, to the fullest extent permitted by Texas law.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "The App is not intended for use in emergency situations or as a safety-critical system.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Nothing in this Section is intended to waive or release any claim of a minor that cannot be waived as a matter of law. All releases, waivers, and assumptions of risk apply only to adult users and only to the maximum extent permitted by applicable law.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 10.h,),

              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "17. Indemnification",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "You agree to indemnify, defend, and hold harmless PMcC Solutions, its members, officers, employees, contractors, and affiliates from any claims, damages, liabilities, or expenses arising from:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "Your use or misuse of the App",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Your violation of this Agreement",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Your exported or shared data",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Your violation of any law or third-party rights.",
              ),
              SizedBox(height: 10.h,),

              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "18. Termination",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "PMcC Solutions may suspend or terminate your access to the App at any time for violation of this Agreement or to protect the integrity or security of the Services.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "You may stop using the App at any time. Fees already paid are non-refundable unless required by law.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Sections relating to ownership, intellectual property, data responsibility, assumption of risk, disclaimers, limitations of liability, indemnification, dispute resolution, governing law, venue, and payment obligations survive termination of this Agreement.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 10.h,),

              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "19. Governing Law",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "This Agreement is governed by the laws of the State of Texas, without regard to conflict-of-law principles.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 10.h,),

              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "20. Mandatory Arbitration and Class-Action Waiver",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Any dispute arising out of or relating to this Agreement or the App shall be resolved exclusively through binding arbitration administered by the American Arbitration Association (AAA) under its Consumer Arbitration Rules.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "Arbitration shall take place in Travis County, Texas",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "You waive any right to a jury trial.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "You waive any right to participate in a class, collective, or representative action.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Only individual claims may be brought.",
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Opt-Out Right:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "You may opt out of arbitration within 30 days of first installing the App by emailing:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "contact@swimmetricsapp.com",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "This arbitration requirement applies equally to you and PMcC Solutions. The arbitration shall be conducted on an individual basis only.Arbitration fees and costs shall be allocated in accordance with the AAA Consumer Arbitration Rules.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Notwithstanding the foregoing, either party may bring an individual claim in small claims court if it qualifies and remains an individual action.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "If any portion of this arbitration provision is found unenforceable, any remaining dispute shall be resolved exclusively in the state or federal courts located in Travis County, Texas, and the parties consent to personal jurisdiction and venue therein. ",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "The arbitrator shall have no authority to award relief on a class, collective, or representative basis.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),




              SizedBox(height: 10.h,),

              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "21. Assignment",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "PMcC Solutions may assign this Agreement without restriction. You may not assign or transfer your rights without written consent.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 10.h,),

              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "22. Force Majeure",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Neither party is liable for delays or failures caused by events beyond reasonable control, including third-party platform or payment processor failures.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 10.h,),

              Divider(),

              SizedBox(height: 10.h),

              CustomText(
                  text:
                  "23. Severability",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "If any provision is found unenforceable, the remaining provisions remain in full force and effect.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 10.h,),

              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "24. Entire Agreement and Updates",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "This Agreement, together with the Privacy Policy, constitutes the entire agreement between you and PMcC Solutions regarding SwimMetrics and supersedes all prior agreements.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Apple and Google are not parties to this Agreement and are not responsible for the App, its content, or support.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Export Compliance.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "You represent and warrant that you are not located in, under the control of, or a national or resident of any country subject to U.S. trade sanctions or embargoes, and that you are not listed on any U.S. government restricted or prohibited party list. You agree not to use, export, re-export, or transfer the App in violation of U.S. export laws or regulations.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "We may update these Terms from time to time. Continued use of the App constitutes acceptance of the updated Agreement. We reserve the right to modify, suspend, or discontinue any part of the App or Services at any time, with or without notice.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "PMcC Solutions has no obligation to provide maintenance, updates, enhancements, or technical support unless required by law.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Section headings are for convenience only and do not affect interpretation.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Material changes to data handling practices will be communicated through an updated Privacy Policy and, where required, in-app notice or consent mechanisms.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "You acknowledge that no statements, descriptions, examples, or marketing materials outside this Agreement create any warranty, guarantee, or obligation not expressly stated herein.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "User Assent.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "BY DOWNLOADING, INSTALLING, OR USING THE APP, AND BY CLICKING “ACCEPT” OR A SIMILAR BUTTON WHERE PRESENTED, YOU AFFIRMATIVELY MANIFEST YOUR ASSENT TO THIS AGREEMENT. IF YOU DO NOT AGREE, YOU MUST NOT USE THE APP.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              CustomText(
                  text:
                  "Third-Party Platforms.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),

              CustomText(
                  text:
                  "You acknowledge that Apple and Google are third-party beneficiaries of this Agreement and that, upon your acceptance of this Agreement, Apple and Google shall have the right (and shall be deemed to have accepted the right) to enforce this Agreement against you as a third-party beneficiary.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),

              CustomText(
                  text:
                  "Time Limitation on Claims.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),

              CustomText(
                  text:
                  "Any claim or cause of action arising out of or relating to the App or this Agreement must be brought within one (1) year after the claim arises, or it is permanently barred. ",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Any claim or cause of action arising out of or relating to the App or this Agreement must be brought within one (1) year after the claim arises, or it is permanently barred. ",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 10.h),

              Divider(),

              SizedBox(height: 10.h),

              CustomText(
                text: "25. Google Play Store Terms",
                fontSize: 16.sp,
                color: isDark ? Color(0xffC7C7C7) : Colors.black87,
              ),

              SizedBox(height: 6.h),

              CustomText(
                text:
                "If you download or access the App through the Google Play Store, the following terms apply:",
                fontSize: 14.sp,
                color: isDark ? Color(0xffC7C7C7) : Colors.black87,
              ),

              SizedBox(height: 6.h),

              CustomDottedText(
                isDark: isDark,
                title:
                "This Agreement is between you and PMcC Solutions LLC only, not Google LLC.",
              ),

              CustomDottedText(
                isDark: isDark,
                title:
                "Google is not responsible for the App or its content.",
              ),

              CustomDottedText(
                isDark: isDark,
                title:
                "PMcC Solutions LLC is solely responsible for maintenance and support of the App.",
              ),

              CustomDottedText(
                isDark: isDark,
                title:
                "Google has no obligation to provide maintenance or support services.",
              ),

              CustomDottedText(
                isDark: isDark,
                title:
                "Google is not responsible for claims related to product liability, legal compliance, or consumer protection.",
              ),

              CustomDottedText(
                isDark: isDark,
                title:
                "PMcC Solutions LLC is responsible for handling intellectual property claims.",
              ),

              CustomDottedText(
                isDark: isDark,
                title:
                "Google is a third-party beneficiary and may enforce this Agreement.",
              ),

              SizedBox(height: 10.h),

              Divider(),

              SizedBox(height: 10.h),

              CustomText(
                text: "26. Notices",
                fontSize: 16.sp,
                color: isDark ? Color(0xffC7C7C7) : Colors.black87,
              ),

              SizedBox(height: 6.h),

              CustomText(
                text:
                "All notices or communications under this Agreement will be sent electronically.",
                fontSize: 14.sp,
                color: isDark ? Color(0xffC7C7C7) : Colors.black87,
              ),

              CustomDottedText(
                isDark: isDark,
                title:
                "Contact PMcC Solutions at contact@swimmetricsapp.com.",
              ),

              CustomDottedText(
                isDark: isDark,
                title:
                "User notices will be sent to the registered email address.",
              ),

              CustomDottedText(
                isDark: isDark,
                title:
                "Electronic communication satisfies legal notice requirements.",
              ),

              SizedBox(height: 10.h),

              Divider(),

              SizedBox(height: 10.h),

              CustomText(
                text: "27. General Legal Terms",
                fontSize: 16.sp,
                color: isDark ? Color(0xffC7C7C7) : Colors.black87,
              ),

              SizedBox(height: 6.h),

              CustomDottedText(
                isDark: isDark,
                title:
                "No Insurance Undertaking: The App does not provide insurance, safety guarantees, or risk mitigation.",
              ),

              CustomDottedText(
                isDark: isDark,
                title:
                "No Reliance: You have not relied on statements outside this Agreement.",
              ),

              CustomDottedText(
                isDark: isDark,
                title:
                "Certain provisions survive termination, including liability limits, arbitration, and governing law.",
              ),

              SizedBox(height: 10.h),

              Divider(),

              SizedBox(height: 10.h),

              CustomText(
                text: "28. Contact Information",
                fontSize: 16.sp,
                color: isDark ? Color(0xffC7C7C7) : Colors.black87,
              ),

              SizedBox(height: 6.h),

              CustomText(
                text: "For questions about these Terms or the App:",
                fontSize: 14.sp,
                color: isDark ? Color(0xffC7C7C7) : Colors.black87,
              ),

              CustomDottedText(
                isDark: isDark,
                title: "Email: contact@swimmetricsapp.com",
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