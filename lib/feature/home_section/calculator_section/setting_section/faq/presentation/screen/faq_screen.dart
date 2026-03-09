import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_primary_button.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

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
          child: Divider(height: 0.5.h, thickness: 1, color: isDark?Color(0xffDADADA):Colors.grey.shade300),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark?Color(0xff1B3A5C):Colors.white,
            borderRadius: BorderRadius.circular(8),
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
              SizedBox(height: 30.h,),

              /// Title
               CustomText(
                 text:
                "FAQs",

                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark?AppColors.textWhite:Color(0xff1D2130),

              ),

             SizedBox(height: 12.h),

              CustomText(text:
                "Everything you need to know about the product and billing. "
                    "Can’t find the answer you’re looking for? Please send your query in Support.",

                  fontSize: 15.sp,
                  color: isDark?Color(0xffC7C7C7):Colors.black54,


              ),

             SizedBox(height: 24.h),

              faqItem(
                "Is there a free trial available?",
                "Yes, you can try us for free for 30 days. If you want, we’ll provide "
                    "you with a free, personalized 30-minute onboarding call to get "
                    "you up and running as soon as possible.",
                isDark
              ),

              faqItem(
                "Can I change my plan later?",
                "Of course. Our pricing scales with your company. Chat to our "
                    "friendly team to find a solution that works for you.",
                  isDark
              ),

              faqItem(
                "What is your cancellation policy?",
                "We understand that things change. You can cancel your plan at "
                    "any time and we’ll refund you the difference already paid.",
                  isDark

              ),

              faqItem(
                "Can other info be added to an invoice?",
                "Yes, you can try us for free for 30 days. If you want, we’ll provide "
                    "you with a free, personalized 30-minute onboarding call to get "
                    "you up and running as soon as possible.",
                  isDark
              ),

              faqItem(
                "How does billing work?",
                "Plans are per workspace, not per account. You can upgrade one "
                    "workspace, and still have any number of free workspaces.",
                  isDark
              ),

              faqItem(
                "How do I change my account email?",
                "You can change the email address associated with your account "
                    "by going to untitled.com/account from a laptop or desktop.",
                  isDark
              ),

             SizedBox(height: 24.h),

              /// Support Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark?Color(0xff032B46):Color(0xffF1F1F1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                   CustomText(
                     text:
                      "Still have questions?",

                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color:isDark?AppColors.textWhite: Color(0xff1D2130),

                    ),

                    SizedBox(height: 10.h),

                    CustomText(text:
                      "Can’t find the answer you’re looking for? "
                          "Please send your query in support.",

                        color:isDark? Color(0xffC7C7C7):Colors.black54,

                    ),

                   SizedBox(height:24.h),
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

  Widget faqItem(String question, String answer,isDark) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 22.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

         CustomText(text:
            question,

              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark?AppColors.textWhite:Color(0xff1D2130),

          ),

          SizedBox(height: 8.h),

         CustomText(
           text:
            answer,

              fontSize: 14.sp,
              color: isDark?Color(0xffC7C7C7):Colors.black54,

          ),
        ],
      ),
    );
  }
}