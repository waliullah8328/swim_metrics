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
    final textColor = isDark ? const Color(0xffC7C7C7) : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppLocalizations.of(context)!.privacyPolicy,
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
              /// Header Info
              Center(
                child: CustomText(
                  text: "Effective Date: March 16, 2026",
                  color: isDark ? const Color(0xff2DA8F0) : const Color(0xff5BA9C7),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: CustomText(
                  text: "SwimMetrics Privacy Policy",
                  fontSize: 20.sp,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              CustomText(
                text: "Operated by PMcC Solutions LLC, a Texas limited liability company (PMcC Solutions)",
                fontSize: 14.sp,
                color: textColor,
              ),
              SizedBox(height: 10.h),
              const Divider(),
              SizedBox(height: 10.h),

              /// Section 1
              sectionTitle("1. Overview and Design Philosophy"),
              sectionBody("SwimMetrics is designed to operate as a local-only, device-based software application. The App’s core functionality does not require user accounts, cloud services, centralized databases, or server-side data processing.", textColor),
              sectionBody("We do not collect, access, store, or transmit personal information through the App’s core functionality. All calculations, projections, and outputs are generated locally on the user’s device and remain under the user’s control unless the user affirmatively chooses to export or share them.", textColor),

              /// Section 2
              sectionTitle("2. Information We Do Not Intentionally Collect"),
              sectionBody("Through the App’s core functionality, the Company does not collect, access, store, or transmit personal information, including:", textColor),
              CustomDottedText(isDark: isDark, title: "Names, usernames, or contact information"),
              CustomDottedText(isDark: isDark, title: "Email addresses or phone numbers"),
              CustomDottedText(isDark: isDark, title: "Location, GPS, or precise geolocation data"),
              CustomDottedText(isDark: isDark, title: "Training logs, race data, or performance history"),
              CustomDottedText(isDark: isDark, title: "Stopwatch times, splits, projections, or conversion outputs"),
              CustomDottedText(isDark: isDark, title: "Device identifiers for analytics, profiling, or tracking purposes"),
              CustomDottedText(isDark: isDark, title: "Cookies, advertising identifiers, or behavioral tracking data"),
              CustomDottedText(isDark: isDark, title: "User accounts, login credentials, or authentication data"),
              sectionBody("The App does not incorporate third-party analytics SDKs, advertising networks, tracking pixels, or similar data-collection technologies.", textColor),
              sectionBody("Except as required by law or valid legal process, we do not seek to obtain or access any personal information through the App.", textColor),

              /// Section 3
              sectionTitle("3. Local-Only Processing and User Control"),
              sectionBody("All numeric inputs, calculations, pacing models, projections, and timing outputs are processed entirely on the user’s device. The Company does not receive, back up, synchronize, mirror, or store this data on external servers.", textColor),
              sectionBody("Access to App data is governed solely by the user’s device-level security controls, including operating system permissions, passcodes, biometric authentication, encryption, and other protections provided by the device manufacturer. We do not manage or control these security features.", textColor),

              /// Section 4
              sectionTitle("4. Exported or Shared Data"),
              sectionBody("If you choose to export, save, print, or share outputs (including but not limited to PDFs, images, reports, screenshots, or timing sheets):", textColor),
              CustomDottedText(isDark: isDark, title: "Data leaves the App only at your explicit direction."),
              CustomDottedText(isDark: isDark, title: "The Company does not monitor, retrieve, review, or control exported content."),
              CustomDottedText(isDark: isDark, title: "You are solely responsible for the security, storage, distribution, attribution, and lawful use of exported data."),
              CustomDottedText(isDark: isDark, title: "The Company disclaims all responsibility and liability for how exported data is handled, interpreted, shared, stored, or used by third parties."),

              /// Section 5
              sectionTitle("5. Payments and Subscriptions"),
              sectionBody("All purchases, subscriptions, renewals, and cancellations are processed exclusively through the Apple App Store or Google Play Store, depending on your device.", textColor),
              sectionBody("The Company does not receive, store, or have access to:", textColor),
              CustomDottedText(isDark: isDark, title: "Credit or debit card numbers"),
              CustomDottedText(isDark: isDark, title: "Billing addresses"),
              CustomDottedText(isDark: isDark, title: "Payment credentials or financial account information"),
              sectionBody("All financial transactions and related data handling are governed by the privacy and security policies of Apple or Google, as applicable.", textColor),

              /// Section 6
              sectionTitle("6. Third-Party Platforms and Operating Systems"),
              sectionBody("Although we do not intentionally collect personal data through the App, device manufacturers, operating systems, and app distribution platforms (including Apple and Google) may independently collect certain information, such as crash diagnostics, system logs, fraud prevention data, or transaction metadata.", textColor),
              sectionBody("Any such collection is governed exclusively by the privacy policies of those third parties and is outside the control of the Company.", textColor),

              /// Section 7
              sectionTitle("7. Children’s Privacy"),
              sectionBody("SwimMetrics is intended for users thirteen (13) years of age or older, consistent with the App’s Terms and Conditions.", textColor),
              sectionBody("The Company does not knowingly collect personal information from children. Minors may use the App only under the supervision of a parent, legal guardian, or coach, who assumes responsibility for the minor’s use of the App and for any exported or shared data.", textColor),

              /// Section 8
              sectionTitle("8. No Data Security or Monitoring Undertaking"),
              sectionBody("Because we do not collect or store user data, we do not provide data hosting, backup, monitoring, breach detection, or notification services. Users are solely responsible for securing their devices and managing any exported or shared data.", textColor),
              sectionBody("Nothing in this Privacy Policy creates an obligation for the Company to provide centralized data safeguarding, recovery, monitoring, or insurance for user data.", textColor),

              /// Section 9
              sectionTitle("9. Future Features and Data Practices"),
              sectionBody("The Company may introduce optional features in the future that require limited data processing (such as cloud synchronization, analytics, or account-based functionality). Any such features will be governed by an updated Privacy Policy and, where required by law or platform rules, will be disclosed to users and subject to user consent prior to activation.", textColor),

              /// Section 10
              sectionTitle("10. Changes to This Privacy Policy"),
              sectionBody("We may update this Privacy Policy from time to time. Continued use of SwimMetrics after an updated Privacy Policy becomes effective constitutes acceptance of the revised policy.", textColor),
              sectionBody("Material changes affecting data-handling practices will be communicated through an updated Privacy Policy and, where required, through in-app notice or platform-level disclosure.", textColor),

              /// Section 11
              sectionTitle("11. Contact Information"),
              sectionBody("Communications sent to us outside the App (such as emails) are handled solely for the purpose of responding to inquiries and are not part of the App’s core functionality.", textColor),
              sectionBody("For questions regarding this Privacy Policy or SwimMetrics:", textColor),
              sectionBody("Email: contact@swimmetricsapp.com", textColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget sectionBody(String text, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: CustomText(
        text: text,
        fontSize: 14.sp,
        color: color,
      ),
    );
  }
}