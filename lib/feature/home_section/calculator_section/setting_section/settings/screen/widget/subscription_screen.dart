import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/feature/auth/sign_up_section/payment/presentation/screen/payment_screen.dart';
import 'package:swim_metrics/feature/auth/sign_up_section/payment/presentation/screen/widget/premium_card_shimmer_widget.dart';

import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../../../core/common/widgets/new_custon_widgets/custom_primary_button.dart';
import '../../../../../../../core/utils/constants/icon_path.dart';
import '../../../../../../auth/sign_up_section/payment/river_pod/payment_controller.dart';
import '../../riverpod/user_plan_controller.dart';





class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key, required this.token,});

  final String token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final payment = ref.watch(getUserPaymentProvider);


    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppLocalizations.of(context)!.smallSubscription,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.only(left: 24.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text:
                  AppLocalizations.of(context)!.currentPlan,

                  color: isDark ? Colors.white : Color(0xff131520),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,

                ),
              ),
            ),
            payment.when(
              data: (data) {
                return Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 20.h),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF0C3156) : AppColors.textWhite,

                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? Color(0xFF2F6F9F) : AppColors.textWhite,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.4)
                            : Color(0xff000000).withValues(alpha: 0.35),
                        blurRadius: 8,
                        spreadRadius: 0,

                      ),
                    ],

                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Top Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text:
                            AppLocalizations.of(context)!.premium,

                            fontSize: 22.h,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFC247),

                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomText(
                                text:
                                "\$${data.actualPrice}",

                                fontSize: 26.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFC247),
                              ),

                              SizedBox(height: 2.h),
                              CustomText(
                                text:
                                AppLocalizations.of(context)!.paid,

                                fontSize: 12.sp,
                                color: Color(0xff2DA8F0),

                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      /// Features
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.features.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(

                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 4,
                        ),
                        itemBuilder: (context, index) {
                          final feature = data.features[index];

                          return _FeatureItem(text: feature);
                        },
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(

                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(IconPath.calenderIconOne),
                                  SizedBox(width: 10.w,),
                                  CustomText(text: AppLocalizations.of(context)!.planStarted,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,),
                                ],
                              ),
                              SizedBox(height: 6.h,),
                              Row(
                                children: [
                                  SizedBox(width: 28.w,),
                                  CustomText(text: formatDate(data.planStartDate
                                      .toString()),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,),
                                ],
                              ),
                            ],
                          ),
                          Column(

                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(IconPath.calenderIconOne,
                                    colorFilter: ColorFilter.mode(
                                        Color(0xffC8AA52), BlendMode.srcIn),),
                                  SizedBox(width: 10.w,),
                                  CustomText(text: AppLocalizations.of(context)!.nextRenewal,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xffC8AA52,),
                                  )
                                ],
                              ),
                              SizedBox(height: 6.h,),
                              Row(
                                children: [
                                  SizedBox(width: 28.w,),
                                  CustomText(
                                    text: formatDate(data.planEndDate
                                        .toString()),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 26.h,),
                      Consumer(builder: (context, ref, child) {
                        final isLoading = ref.read(
                            paymentProvider.select((s) => s.paymentLoading));
                        return CustomPrimaryButton(onPressed: () async {
                          final result = await ref.read(
                              paymentProvider.notifier).paymentFunction(
                              context: context, token: token);
                          if (result) {
                            // context.go(RouteNames.loginScreen);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  PaymentScreen(token: token),));
                          }


                          //context.go(RouteNames.getStartedScreen);
                        },
                          title: AppLocalizations.of(context)!.upgradePlan,
                          isLoading: isLoading,);
                      },),
                      SizedBox(height: 10,),

                      Align(
                          alignment: Alignment.center,
                          child: CustomText(text: "${data.remainingDays} ${AppLocalizations.of(context)!.daysRemaining}",
                            color: Color(0xffFFB0B2),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center,))


                    ],
                  ),
                );
              },
              error: (error, stack) =>
                  Center(child: CustomText(text: "No data found")),
              loading: () => PremiumCardShimmer(isDark: isDark,),
            ),


          ],
        ),
      ),
    );
  }
  String formatDate(String? date) {
    if (date == null || date.isEmpty) return '';

    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return '';
    }
  }

}

class _FeatureItem extends StatelessWidget {
  final String text;
  const _FeatureItem({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          SvgPicture.asset(IconPath.ticMarkIcon,colorFilter: ColorFilter.mode(isDark?Color(0xffBABABA):Colors.black, BlendMode.srcIn),),
          SizedBox(width: 8.w),
          Expanded(
            child: CustomText(
              text:
              text,


              fontSize: 14.sp,
              color: isDark?Color(0xffF7F9FA):Color(0xff82888E),

            ),
          )
        ],
      ),
    );
  }
}