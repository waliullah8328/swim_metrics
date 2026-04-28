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
                text: "These Terms and Conditions of Use (\"Agreement\") govern your access to and use of the SwimMetrics mobile application, including all calculations, tools, features, content, and related services (collectively, the \"App\" or \"Services\").\n\nBy downloading, installing, accessing, or using SwimMetrics, you acknowledge that you have read, understood, and agree to be bound by this Agreement and the SwimMetrics Privacy Policy.\n\nIf you do not agree, you must immediately discontinue use and uninstall the App.",
                fontSize: 14.sp,
                color: textColor,
              ),

              const Divider(height: 32),

              _buildSection(
                "1. Purpose of SwimMetrics",
                "SwimMetrics provides race-split calculations, pacing projections, course conversions, timing tools, and related performance-analysis features for swimmers and coaches.\n\n"
                    "The App is provided solely for informational and training-support purposes. It is not a substitute for professional coaching, certified instruction, medical advice, therapeutic guidance, or safety supervision.\n\n"
                    "All calculations, ratios, pacing models, and projections are estimates only and are not affiliated with or endorsed by any governing body.\n\n"
                    "Unauthorized reproduction, redistribution, reverse engineering, data extraction, or competitive analysis using SwimMetrics' content is strictly prohibited.",
                textColor,
              ),

              _buildSection(
                "2. No Duty of Care",
                "Use of SwimMetrics does not create any duty of care, professional relationship, fiduciary relationship, coaching relationship, or medical relationship between you and the Company. We do not owe duty to monitor, supervise, verify, or correct any training decisions, athletic activities, or reliance on App outputs.",
                textColor,
              ),

              _buildSection(
                "3. Eligibility and Age Requirements",
                "SwimMetrics is intended for users thirteen (13) years of age or older.\n\n"
                    "If you are a minor, you may use the App only under the supervision of a parent, legal guardian, or coach, who agrees to be bound by this Agreement and is responsible for all use, exported files, and shared data involving minors. SwimMetrics is not directed to children under the age of thirteen (13) and is not intended for use by children without supervision as described herein.\n\n"
                    "You represent that you have the legal capacity to enter into this Agreement.",
                textColor,
              ),

              _buildSection(
                "4. Minors and Parental Responsibility",
                "By permitting a minor to use SwimMetrics, the parent, legal guardian, or supervising coach acknowledges and agrees that athletic training involves inherent risks and voluntarily assumes all risks associated with the minor's use of the App. By permitting a minor to download, install, or use the App on any device under your control, you affirmatively consent to this Agreement on the minor's behalf.\n\n"
                    "We disclaim any responsibility for supervision, instruction, or safety of minors.\n\n"
                    "To the extent permitted by applicable law, this Agreement does not purport to waive, release, or limit any rights or claims of a minor that cannot legally be waived on the minor's behalf. Any provisions relating to assumption of risk, release, indemnification, or limitation of liability apply only to the maximum extent enforceable under applicable law and do not invalidate the remainder of this Agreement.",
                textColor,
              ),

              _buildSection(
                "5. Subscription, Billing, and Payments (If Applicable)",
                "Certain features of SwimMetrics may require a paid subscription.\n\n"
                    "All subscriptions, renewals, cancellations, and payments are processed exclusively through Apple App Store or Google Play, depending on your device.\n\n"
                    "Subscriptions renew automatically unless canceled at least 24 hours before the renewal date.\n\n"
                    "Prices may change in accordance with App Store and Google Play policies and without advance notice.\n\n"
                    "Canceling a subscription stops future charges but does not refund prior payments.\n\n"
                    "We do not issue refunds. Refund requests must be directed to Apple or Google under their respective policies.",
                textColor,
              ),

              _buildSection(
                "6. License Grant",
                "Subject to your compliance with this Agreement, we grant you a limited, non-exclusive, non-transferable, non-sublicensable, revocable license to install and use the App solely for personal, non-commercial use.\n\n"
                    "No rights are granted except those expressly stated herein.",
                textColor,
              ),

              _buildSection(
                "7. User Responsibilities",
                "You agree to:\n\n"
                    "• Use SwimMetrics safely, responsibly, and lawfully.\n"
                    "• Not use the App while driving or during activities requiring full attention.\n"
                    "• Not rely on the App for emergency, safety-critical, or life-saving purposes.\n"
                    "• Ensure the accuracy of all numeric inputs you enter.\n"
                    "• Comply with all applicable laws, sport regulations, and organizational requirements.\n"
                    "• Assume all risks associated with physical activity, training decisions, and reliance on App outputs.\n\n"
                    "You acknowledge that you exercise independent judgment in all training, pacing, and performance decisions and that you do not rely on SwimMetrics as the sole or primary basis for any athletic, health, or safety decision.\n\n"
                    "You acknowledge that the App does not replace judgment, experience, supervision, or professional instruction, and that App outputs are only one of many factors you may consider when making training or performance decisions. You acknowledge that SwimMetrics provides computational assistance only and does not make decisions or recommendations on your behalf.",
                textColor,
              ),

              _buildSection(
                "8. User Control",
                "You acknowledge that you control all training variables, including intensity, duration, rest, and participation, and that the Company does not monitor, enforce, or limit any physical activity or training decisions.",
                textColor,
              ),

              _buildSection(
                "9. Prohibited Uses and Restrictions",
                "You agree that you will not, directly or indirectly:\n\n"
                    "• Use the App for unlawful purposes or in violation of any law.\n"
                    "• Reverse engineer, decompile, disassemble, decode, or attempt to extract source code, algorithms, pacing ratios, conversion logic, data models, or proprietary logic.\n"
                    "• Copy, modify, distribute, translate, adapt, scrape, benchmark, or create derivative works of the App.\n"
                    "• Use the App for competitive analysis or to develop or improve competing products or services.\n"
                    "• Remove, alter, or obscure proprietary notices or branding.\n"
                    "• Interfere with security features or attempt unauthorized access to systems or data.\n"
                    "• Upload harmful code, malware, or automated scripts (the App permits numeric input only).\n"
                    "• Misuse exported files, timing logs, or athlete data, including data relating to minors.\n"
                    "• Use the App in a manner that violates data-protection or privacy laws.\n\n"
                    "Any prohibited use immediately terminates your license.",
                textColor,
              ),

              _buildSection(
                "10. Ownership and Intellectual Property",
                "The App and all related intellectual property—including but not limited to:\n\n"
                    "• software, code, databases, and algorithms\n"
                    "• pacing ratios, analytics models, and prediction tools\n"
                    "• conversion logic and timing methodologies\n"
                    "• UI/UX design, documentation, branding, trademarks, and logos\n"
                    "• updates, improvements, and derivative works\n\n"
                    "are the exclusive property of the Company and are protected by U.S. and international copyright, trademark, and trade-secret laws. Any feedback or suggestions you provide may be used by us without compensation or obligation.\n\n"
                    "You acquire no ownership interest in the App.",
                textColor,
              ),

              _buildSection(
                "11. Data Handling and Privacy",
                "SwimMetrics is designed so that the App's core functionality operates without collecting, storing, transmitting, synchronizing, or processing personal information on external servers. The App does not require user accounts, and all calculations, timing logs, and projections are processed locally on your device unless you affirmatively choose to export or share them.\n\n"
                    "We do not have access to user-entered data generated through the App's core functionality. You are solely responsible for securing your device and for the storage, distribution, and lawful use of any exported or shared data.\n\n"
                    "Communications sent to us outside the App (such as emails or support inquiries) are not part of the App's core functionality and may involve personal information voluntarily provided by you for the purpose of responding to inquiries.\n\n"
                    "Future Features and Data Use: We may, in the future, introduce optional features that require limited collection or processing of user data (such as analytics, cloud synchronization, or account-based functionality). Any such features will be governed by an updated Privacy Policy and, where required by law or platform policy, will be disclosed to users and subject to user consent prior to activation.\n\n"
                    "To the extent platform providers, operating systems, or device manufacturers collect data independently of the Company, such collection is governed by their respective privacy policies and not by this Agreement.\n\n"
                    "In the event of any conflict between these Terms and the Privacy Policy regarding data handling, the Privacy Policy controls.\n\n"
                    "User-Generated Outputs: Any exported files, logs, timing records, or derived outputs are generated solely from user-entered inputs. We do not verify accuracy, ownership, consent, or lawful use of such outputs and disclaims all liability arising from their sharing, publication, or attribution.",
                textColor,
              ),

              _buildSection(
                "12. No Coaching, Medical, or Performance Guarantees",
                "The App provides computational tools only and does not provide medical, therapeutic, diagnostic, or certified coaching advice.\n\n"
                    "All outputs are estimates and may not reflect actual performance.\n\n"
                    "No guarantee is made regarding athletic improvement, race results, or training outcomes.\n\n"
                    "You must consult qualified professionals for training, health, and safety decisions.\n\n"
                    "Consult a physician before beginning any physical activity.\n\n"
                    "You assume all risks associated with reliance on the App.\n\n"
                    "Swimming and athletic training involve inherent risks, including injury or death. You voluntarily assume all such risks.\n\n"
                    "By using the App, you acknowledge that you are voluntarily participating in athletic training activities with known and unknown risks and that you are solely responsible for assessing your own physical condition and limits.\n\n"
                    "For minors, assumption of risk applies only to the extent permitted by applicable law.\n\n"
                    "YOU EXPRESSLY AND VOLUNTARILY ASSUME ALL RISKS ASSOCIATED WITH USE OF THE APP, RELIANCE ON APP OUTPUTS, AND PARTICIPATION IN ANY ATHLETIC OR TRAINING ACTIVITIES.",
                textColor,
              ),

              _buildSection(
                "13. Software-Only Product",
                "SwimMetrics is a software application that provides informational calculations only and does not constitute sporting equipment, safety equipment, or a physical product. The Company disclaims any liability under theories of product liability or strict liability to the fullest extent permitted by law.",
                textColor,
              ),

              _buildSection(
                "14. Disclaimer of Warranties",
                "THE APP IS PROVIDED \"AS IS\" AND \"AS AVAILABLE\", WITHOUT WARRANTIES OF ANY KIND, EXPRESS, IMPLIED, OR STATUTORY.\n\n"
                    "WE DISCLAIM ALL WARRANTIES, INCLUDING MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, ACCURACY, RELIABILITY, AND NON-INFRINGEMENT.\n\n"
                    "We do not warrant that the App will be uninterrupted, error-free, or meet your specific requirements.",
                textColor,
              ),

              _buildSection(
                "15. Limitation of Liability",
                "TO THE MAXIMUM EXTENT PERMITTED BY LAW:\n\n"
                    "We shall not be liable for indirect, incidental, consequential, punitive, or special damages, including lost profits, lost data, training injuries, athletic outcomes, or reliance on App outputs.\n\n"
                    "Total aggregate liability shall not exceed the amount you paid for the App or subscription during the twelve (12) months preceding the claim.\n\n"
                    "Some jurisdictions do not allow certain limitations; in those cases, limitations apply to the fullest extent permitted.\n\n"
                    "To the fullest extent permitted by applicable law, the Company shall have no liability for any bodily injury, illness, disability, or death arising from or related to use of the App, reliance on App outputs, training decisions, or athletic activity, whether such claims are based in contract, tort, negligence, strict liability, or otherwise.\n\n"
                    "These limitations apply even if the Company has been advised of the possibility of such damages.\n\n"
                    "These limitations are a fundamental basis of the bargain between you and the Company and shall apply even if any limited remedy fails for its essential purpose.",
                textColor,
              ),

              _buildSection(
                "16. READ CAREFULLY – Release of Claims, Assumption of Risk, and Release of Negligence (Texas Law)",
                "TO THE FULLEST EXTENT PERMITTED BY LAW, you hereby release, waive, and discharge the Company, SwimMetrics, and their members, officers, employees, contractors, and affiliates from any and all claims, demands, causes of action, damages, or liabilities of any kind, whether known or unknown, arising out of or related to:\n\n"
                    "(a) your use of the App;\n"
                    "(b) reliance on App outputs;\n"
                    "(c) training, competition, or athletic activity; or\n"
                    "(d) injury, illness, disability, or death.\n\n"
                    "This release expressly includes, and is intended to release, claims based on the ordinary negligence of the Company and its affiliates, to the fullest extent permitted by Texas law.\n\n"
                    "The App is not intended for use in emergency situations or as a safety-critical system.\n\n"
                    "Nothing in this Section is intended to waive or release any claim of a minor that cannot be waived as a matter of law. All releases, waivers, and assumptions of risk apply only to adult users and only to the maximum extent permitted by applicable law.",
                textColor,
              ),

              _buildSection(
                "17. Indemnification",
                "You agree to indemnify, defend, and hold harmless the Company, its members, officers, employees, contractors, and affiliates from any claims, damages, liabilities, or expenses arising from:\n\n"
                    "• your use or misuse of the App;\n"
                    "• your violation of this Agreement;\n"
                    "• your exported or shared data;\n"
                    "• your violation of any law or third-party rights.",
                textColor,
              ),

              _buildSection(
                "18. Termination",
                "We may suspend or terminate your access to the App at any time for violation of this Agreement or to protect the integrity or security of the Services.\n\n"
                    "You may stop using the App at any time. Fees already paid are non-refundable unless required by law.\n\n"
                    "Sections relating to ownership, intellectual property, data responsibility, assumption of risk, disclaimers, limitations of liability, indemnification, dispute resolution, governing law, venue, and payment obligations survive termination of this Agreement.",
                textColor,
              ),

              _buildSection(
                "19. Governing Law",
                "This Agreement is governed by the laws of the State of Texas, without regard to conflict-of-law principles.",
                textColor,
              ),

              _buildSection(
                "20. Mandatory Arbitration and Class-Action Waiver",
                "Any dispute arising out of or relating to this Agreement or the App shall be resolved exclusively through binding arbitration administered by the American Arbitration Association (AAA) under its Consumer Arbitration Rules.\n\n"
                    "Arbitration shall take place in Travis County, Texas.\n\n"
                    "You waive any right to a jury trial.\n\n"
                    "You waive any right to participate in a class, collective, or representative action.\n\n"
                    "Only individual claims may be brought.\n\n"
                    "Opt-Out Right: You may opt out of arbitration within 30 days of first installing the App by emailing: contact@swimmetricsapp.com\n\n"
                    "This arbitration requirement applies equally to you and the Company. The arbitration shall be conducted on an individual basis only.\n\n"
                    "Arbitration fees and costs shall be allocated in accordance with the AAA Consumer Arbitration Rules.\n\n"
                    "Notwithstanding the foregoing, either party may bring an individual claim in small claims court if it qualifies and remains an individual action.\n\n"
                    "If any portion of this arbitration provision is found unenforceable, any remaining dispute shall be resolved exclusively in the state or federal courts located in Travis County, Texas, and the parties consent to personal jurisdiction and venue therein.\n\n"
                    "The arbitrator shall have no authority to award relief on a class, collective, or representative basis.",
                textColor,
              ),

              _buildSection(
                "21. Assignment",
                "We may assign this Agreement without restriction. You may not assign or transfer your rights without written consent.",
                textColor,
              ),

              _buildSection(
                "22. Force Majeure",
                "Neither party is liable for delays or failures caused by events beyond reasonable control, including third-party platform or payment processor failures.",
                textColor,
              ),

              _buildSection(
                "23. Severability",
                "If any provision is found unenforceable, the remaining provisions remain in full force and effect.",
                textColor,
              ),

              _buildSection(
                "24. Entire Agreement and Updates",
                "This Agreement, together with the Privacy Policy, constitutes the entire agreement between you and the Company regarding SwimMetrics and supersedes all prior agreements.\n\n"
                    "Apple and Google are not parties to this Agreement and are not responsible for the App, its content, or support.\n\n"
                    "Export Compliance: You represent and warrant that you are not located in, under the control of, or a national or resident of any country subject to U.S. trade sanctions or embargoes, and that you are not listed on any U.S. government restricted or prohibited party list. You agree not to use, export, re-export, or transfer the App in violation of U.S. export laws or regulations.\n\n"
                    "We may update these Terms from time to time. Continued use of the App constitutes acceptance of the updated Agreement. We reserve the right to modify, suspend, or discontinue any part of the App or Services at any time, with or without notice.\n\n"
                    "We have no obligation to provide maintenance, updates, enhancements, or technical support unless required by law.\n\n"
                    "Section headings are for convenience only and do not affect interpretation.\n\n"
                    "Material changes to data handling practices will be communicated through an updated Privacy Policy and, where required, in-app notice or consent mechanisms.\n\n"
                    "You acknowledge that no statements, descriptions, examples, or marketing materials outside this Agreement create any warranty, guarantee, or obligation not expressly stated herein.\n\n"
                    "User Assent: BY DOWNLOADING, INSTALLING, OR USING THE APP, AND BY CLICKING \"ACCEPT\" OR A SIMILAR BUTTON WHERE PRESENTED, YOU AFFIRMATIVELY MANIFEST YOUR ASSENT TO THIS AGREEMENT. IF YOU DO NOT AGREE, YOU MUST NOT USE THE APP.\n\n"
                    "Third-Party Platforms: You acknowledge that Apple and Google are third-party beneficiaries of this Agreement and that, upon your acceptance of this Agreement, Apple and Google shall have the right (and shall be deemed to have accepted the right) to enforce this Agreement against you as a third-party beneficiary.\n\n"
                    "Time Limitation on Claims: Any claim or cause of action arising out of or relating to the App or this Agreement must be brought within one (1) year after the claim arises, or it is permanently barred.\n\n"
                    "Apple App Store–Specific Terms:\n"
                    "This Agreement is concluded between you and the Company only, and not with Apple Inc. Apple is not responsible for the App or its content. The Company, and not Apple, is solely responsible for providing maintenance and support for the App. To the extent any applicable warranty has not been effectively disclaimed, Apple will have no warranty obligation whatsoever, and any claims, losses, liabilities, damages, costs, or expenses attributable to any failure to conform to any warranty shall be the sole responsibility of the Company.\n\n"
                    "You acknowledge that Apple is not responsible for addressing any claims relating to the App or your possession or use of the App, including but not limited to: (a) product liability claims; (b) any claim that the App fails to conform to any applicable legal or regulatory requirement; and (c) claims arising under consumer protection, privacy, or similar laws.\n\n"
                    "You acknowledge and agree that Apple and its subsidiaries are third-party beneficiaries of this Agreement and, upon your acceptance of this Agreement, Apple shall have the right to enforce this Agreement against you as a third-party beneficiary.\n\n"
                    "Google Play Store–Specific Terms:\n"
                    "If you download or access the App through the Google Play Store, the following terms apply: This Agreement is concluded between you and the Company only, and not with Google LLC or any of its affiliates (\"Google\"). Google is not responsible for the App or its content. The Company, and not Google, is solely responsible for providing maintenance and support for the App, as specified in this Agreement or as required by applicable law. Google has no obligation whatsoever to furnish any maintenance or support services with respect to the App.\n\n"
                    "You acknowledge that Google is not responsible for addressing any claims you may have relating to the App or your possession or use of the App, including but not limited to: (a) product liability claims; (b) any claim that the App fails to conform to any applicable legal or regulatory requirement; or (c) claims arising under consumer protection, privacy, or similar laws.\n\n"
                    "In the event of any third-party claim that the App or your possession or use of the App infringes that third party's intellectual property rights, the Company, and not Google, shall be solely responsible for the investigation, defense, settlement, and discharge of any such claim.\n\n"
                    "You acknowledge and agree that Google and its affiliates are third-party beneficiaries of this Agreement, and that, upon your acceptance of this Agreement, Google shall have the right (and shall be deemed to have accepted the right) to enforce this Agreement against you as a third-party beneficiary.",
                textColor,
              ),

              _buildSection(
                "25. Notices",
                "Any notices or communications required under this Agreement shall be sent electronically to the Company at contact@swimmetricsapp.com or, for users, to the email address provided in connection with App Store communications. Electronic notice satisfies any legal notice requirement to the fullest extent permitted by law.\n\n"
                    "No Insurance Undertaking: Nothing in this Agreement or the App constitutes an undertaking to provide insurance, safety guarantees, supervision, or risk mitigation of any kind.\n\n"
                    "No Reliance: You acknowledge that you have not relied on any representations, statements, or assurances not expressly set forth in this Agreement.\n\n"
                    "All provisions which by their nature should survive termination shall survive, including but not limited to Sections relating to assumption of risk, release of claims, disclaimers, limitation of liability, indemnification, arbitration, governing law, venue, and time limitations.",
                textColor,
              ),

              SizedBox(height: 20.h),
              const Divider(),
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