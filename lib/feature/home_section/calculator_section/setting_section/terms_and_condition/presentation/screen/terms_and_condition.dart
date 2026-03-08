import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../../core/utils/constants/icon_path.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          text: "Terms & Conditions",
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
          child: Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
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

                    color: Color(0xff5BA9C7),
                    fontSize: 14.sp,
                  fontWeight: FontWeight.w600,

                ),
              ),

              const SizedBox(height: 10),

              /// Title
              const Center(
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Your privacy is important to us at Untitled. "
                    "We respect your privacy regarding any information "
                    "we may collect from you across our website.",
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),

              const SizedBox(height: 16),

              const Text(
                "Mi tincidunt elit, id quisque ligula ac diam, amet. "
                    "Vel etiam suspendisse morbi eleifend faucibus eget vestibulum felis. "
                    "Dictum quis montes, sit sit. Tellus aliquam enim urna, etiam. "
                    "Mauris posuere vulputate arcu amet, vitae nisi, tellus tincidunt.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 20),

              sectionTitle("What information do we collect?"),
              sectionText(),

              sectionTitle(
                  "Do we use cookies and other Letter spacing technologies?"),
              sectionText(),

              sectionTitle("How long do we keep your information?"),
              sectionText(),

              sectionTitle("How do we keep your information safe?"),
              sectionText(),

              sectionTitle("What are your privacy rights?"),
              sectionText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget sectionText() {
    return const Text(
      "Pharetra morbi libero id aliquam elit massa integer tellus. "
          "Quis felis aliquam ullamcorper porttitor. Pulvinar ullamcorper "
          "sit dictumst ut eget a, elementum eu. Maecenas est morbi "
          "mattis id in ac pellentesque ac.",
      style: TextStyle(
        fontSize: 14,
        color: Colors.black54,
        height: 1.6,
      ),
    );
  }
}