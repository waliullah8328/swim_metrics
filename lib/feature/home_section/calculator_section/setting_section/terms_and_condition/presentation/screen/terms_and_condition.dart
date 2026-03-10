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
                  "Current as of 20 Mar 2026",

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

                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,

                ),
              ),

               SizedBox(height: 16.h),

              CustomText(
                text:
                "Your privacy is important to us at Untitled. "
                    "We respect your privacy regarding any information "
                    "we may collect from you across our website.",
               fontSize: 15.sp, color: isDark?Color(0xffC7C7C7):Colors.black87
              ),

             SizedBox(height: 16.h),

              CustomText(
                text:
                "Mi tincidunt elit, id quisque ligula ac diam, amet. "
                    "Vel etiam suspendisse morbi eleifend faucibus eget vestibulum felis. "
                    "Dictum quis montes, sit sit. Tellus aliquam enim urna, etiam. "
                    "Mauris posuere vulputate arcu amet, vitae nisi, tellus tincidunt.",
               fontSize: 14.sp, color:isDark?Color(0xffC7C7C7): Colors.black54
              ),

             SizedBox(height: 20.h),

              sectionTitle("What information do we collect?"),
              sectionText(isDark: isDark),
              sectionTitle(
                  "Do we use cookies and other Letter spacing technologies?"),
              sectionText(isDark: isDark),

              sectionTitle("How long do we keep your information?"),
              sectionText(isDark: isDark),

              sectionTitle("How do we keep your information safe?"),
              sectionText(isDark: isDark),

              sectionTitle("What are your privacy rights?"),
              sectionText(isDark: isDark),
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