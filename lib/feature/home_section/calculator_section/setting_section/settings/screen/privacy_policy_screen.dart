import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../../core/utils/constants/icon_path.dart';


import '../../../../../../l10n/app_localizations.dart';
import '../../faq/presentation/screen/faq_screen.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          text: AppLocalizations.of(context)!.privacyPolicy,
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
                "Privacy Policy",

                  fontSize: 20.sp,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,

                ),
              ),

              SizedBox(height: 6.h),

              CustomText(
                  text:
                  "Operated by PMcC Solutions LLC, a Texas limited liability company (“PMcC Solutions,” “we,” “us,” or “our”)",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),


              SizedBox(height: 10.h),
              Divider(),
              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "1. Overview and Design Philosophy",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "SwimMetrics is designed to operate as a local-only, device-based software application. The App’s core functionality does not require user accounts, cloud services, centralized databases, or server-side data processing.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "PMcC Solutions does not collect, access, store, or transmit personal information through the App’s core functionality. All calculations, projections, and outputs are generated locally on the user’s device and remain under the user’s control unless the user affirmatively chooses to export or share them.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 10.h,),
              Divider(),

              SizedBox(height: 10.h),
              CustomText(
                  text:
                  "2. Information We Do Not Intentionally Collect",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Through the App’s core functionality, PMcC Solutions does not collect, access, store, or transmit personal information, including:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "Names, usernames, or contact information",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Email addresses or phone numbers",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Location, GPS, or precise geolocation data",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Training logs, race data, or performance history",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Stopwatch times, splits, projections, or conversion outputs",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Device identifiers for analytics, profiling, or tracking purposes",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Cookies, advertising identifiers, or behavioral tracking data",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "User accounts, login credentials, or authentication data",
              ),
              SizedBox(height: 6.h,),
              CustomText(
                  text:
                  "The App does not incorporate third-party analytics SDKs, advertising networks, tracking pixels, or similar data-collection technologies.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomText(
                  text:
                  "Except as required by law or valid legal process, PMcC Solutions does not seek to obtain or access any personal information through the App.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),



              SizedBox(height: 10.h,),
              Divider(),
              SizedBox(height: 10.h,),
              CustomText(
                  text:
                  "3. Local-Only Processing and User Control",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "All numeric inputs, calculations, pacing models, projections, and timing outputs are processed entirely on the user’s device. PMcC Solutions does not receive, back up, synchronize, mirror, or store this data on external servers.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 6.h,),
              CustomText(
                  text:
                  "Access to App data is governed solely by the user’s device-level security controls, including operating system permissions, passcodes, biometric authentication, encryption, and other protections provided by the device manufacturer. PMcC Solutions does not manage or control these security features.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 10.h,),
              Divider(),
              SizedBox(height: 10.h,),
              CustomText(
                  text:
                  "4. Exported or Shared Data",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "If you choose to export, save, print, or share outputs (including but not limited to PDFs, images, reports, screenshots, or timing sheets):",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "Data leaves the App only at your explicit direction.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "PMcC Solutions does not monitor, retrieve, review, or control exported content.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "You are solely responsible for the security, storage, distribution, attribution, and lawful use of exported data.",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "PMcC Solutions disclaims all responsibility and liability for how exported data is handled, interpreted, shared, stored, or used by third parties.",
              ),
              SizedBox(height: 10.h,),
              Divider(),
              SizedBox(height: 10.h,),
              CustomText(
                  text:
                  "5. Payments and Subscriptions",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "All purchases, subscriptions, renewals, and cancellations are processed exclusively through the Apple App Store or Google Play Store, depending on your device.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomText(
                  text:
                  "PMcC Solutions does not receive, store, or have access to:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomDottedText(
                isDark: isDark,
                title:
                "Credit or debit card numbers",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Billing addresses",
              ),
              CustomDottedText(
                isDark: isDark,
                title:
                "Payment credentials or financial account information",
              ),
              SizedBox(height: 6.h,),
              CustomText(
                  text:
                  "All financial transactions and related data handling are governed by the privacy and security policies of Apple or Google, as applicable.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

              SizedBox(height: 10.h,),
              Divider(),
              SizedBox(height: 10.h,),
              CustomText(
                  text:
                  "6. Third-Party Platforms and Operating Systems",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Although PMcC Solutions does not intentionally collect personal data through the App, device manufacturers, operating systems, and app distribution platforms (including Apple and Google) may independently collect certain information, such as crash diagnostics, system logs, fraud prevention data, or transaction metadata.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h,),
              CustomText(
                  text:
                  "Any such collection is governed exclusively by the privacy policies of those third parties and is outside the control of PMcC Solutions.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 10.h,),
              Divider(),
              SizedBox(height: 10.h,),
              CustomText(
                  text:
                  "7. Children’s Privacy",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "SwimMetrics is intended for users thirteen (13) years of age or older, consistent with the App’s Terms and Conditions.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "PMcC Solutions does not knowingly collect personal information from children. Minors may use the App only under the supervision of a parent, legal guardian, or coach, who assumes responsibility for the minor’s use of the App and for any exported or shared data.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 10.h,),
              Divider(),
              SizedBox(height: 10.h,),
              CustomText(
                  text:
                  "8. No Data Security or Monitoring Undertaking",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Because PMcC Solutions does not collect or store user data, we do not provide data hosting, backup, monitoring, breach detection, or notification services. Users are solely responsible for securing their devices and managing any exported or shared data.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Nothing in this Privacy Policy creates an obligation for PMcC Solutions to provide centralized data safeguarding, recovery, monitoring, or insurance for user data.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 10.h,),
              Divider(),
              SizedBox(height: 10.h,),
              CustomText(
                  text:
                  "9. Future Features and Data Practices",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "PMcC Solutions may introduce optional features in the future that require limited data processing (such as cloud synchronization, analytics, or account-based functionality). Any such features will be governed by an updated Privacy Policy and, where required by law or platform rules, will be disclosed to users and subject to user consent prior to activation.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 10.h,),
              Divider(),
              SizedBox(height: 10.h,),
              CustomText(
                  text:
                  "10. Changes to This Privacy Policy",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "We may update this Privacy Policy from time to time. Continued use of SwimMetrics after an updated Privacy Policy becomes effective constitutes acceptance of the revised policy.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Material changes affecting data-handling practices will be communicated through an updated Privacy Policy and, where required, through in-app notice or platform-level disclosure.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 10.h,),
              Divider(),
              SizedBox(height: 10.h,),
              CustomText(
                  text:
                  "11. Contact Information",
                  fontSize: 16.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Communications sent to PMcC Solutions outside the App (such as emails) are handled solely for the purpose of responding to inquiries and are not part of the App’s core functionality.",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "For questions regarding this Privacy Policy or SwimMetrics:",
                  fontSize: 14.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),
              SizedBox(height: 6.h),
              CustomText(
                  text:
                  "Email: contact@swimmetricsapp.com",
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