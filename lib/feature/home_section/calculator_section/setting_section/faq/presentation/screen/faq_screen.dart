import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_primary_button.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../../core/utils/constants/icon_path.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      appBar: AppBar(
        title: CustomText(
          text: "FAQ",
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

              /// Title
              const Text(
                "FAQs",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1D2130),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Everything you need to know about the product and billing. "
                    "Can’t find the answer you’re looking for? Please send your query in Support.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 24),

              faqItem(
                "Is there a free trial available?",
                "Yes, you can try us for free for 30 days. If you want, we’ll provide "
                    "you with a free, personalized 30-minute onboarding call to get "
                    "you up and running as soon as possible.",
              ),

              faqItem(
                "Can I change my plan later?",
                "Of course. Our pricing scales with your company. Chat to our "
                    "friendly team to find a solution that works for you.",
              ),

              faqItem(
                "What is your cancellation policy?",
                "We understand that things change. You can cancel your plan at "
                    "any time and we’ll refund you the difference already paid.",
              ),

              faqItem(
                "Can other info be added to an invoice?",
                "Yes, you can try us for free for 30 days. If you want, we’ll provide "
                    "you with a free, personalized 30-minute onboarding call to get "
                    "you up and running as soon as possible.",
              ),

              faqItem(
                "How does billing work?",
                "Plans are per workspace, not per account. You can upgrade one "
                    "workspace, and still have any number of free workspaces.",
              ),

              faqItem(
                "How do I change my account email?",
                "You can change the email address associated with your account "
                    "by going to untitled.com/account from a laptop or desktop.",
              ),

              const SizedBox(height: 24),

              /// Support Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xffF1F1F1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Still have questions?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1D2130),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Can’t find the answer you’re looking for? "
                          "Please send your query in support.",
                      style: TextStyle(
                        color: Colors.black54,
                        height: 1.6,
                      ),
                    ),

                   SizedBox(height: 16.h),
                    SizedBox(
                      width: 120.w,
                      child: CustomPrimaryButton(title: "Get in touch",onPressed: (){

                      },),
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

  Widget faqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff1D2130),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            answer,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}