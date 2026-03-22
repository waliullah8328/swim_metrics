import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/feature/auth/sign_up_section/payment/presentation/screen/widget/premium_card_shimmer_widget.dart';
import 'package:swim_metrics/feature/on_boarding/presentation/screens/widget/premium_plan_card_widget.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../../config/route/routes_name.dart';
import '../../../../../../core/common/widgets/new_custon_widgets/custom_primary_button.dart';
import '../../../../../../core/utils/constants/icon_path.dart';
import '../../river_pod/payment_controller.dart';



class PaymentScreen extends ConsumerWidget {
  const PaymentScreen( {super.key,required this.token,});

  final String token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promoCode = ref.watch(promoCodeProvider);
    final isApplying = ref.watch(isApplyingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final payment = ref.watch( getPaymentProvider );


    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppLocalizations.of(context)!.paymentScreen,
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
            SizedBox(height: 80.h),
            Padding(
              padding: EdgeInsets.only(left: 24.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text:
                  AppLocalizations.of(context)!.thePlanWeHave,

                  color: isDark?Colors.white:Color(0xff131520),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,

                ),
              ),
            ),
            payment.when(
                data: (data) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark?Color(0xFF0C3156):AppColors.textWhite,

                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark?Color(0xFF2F6F9F):AppColors.textWhite,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark?Colors.black.withValues(alpha: 0.4):Color(0xff000000).withValues(alpha: 0.35),
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
                              children:  [
                                CustomText(
                                  text:
                                  "\$${data.price}",

                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFC247),
                                ),

                                SizedBox(height: 2.h),
                                CustomText(
                                  text:
                                  AppLocalizations.of(context)!.yearlyPay,

                                  fontSize: 12.sp,
                                  color:Color(0xff2DA8F0),

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
                          itemCount: data.features?.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 4,
                          ),
                          itemBuilder: (context, index) {
                            final featureList = data.features?[index];
                            return _FeatureItem(text: featureList!.featureName.toString());
                          },
                        ),

                        SizedBox(height: 20.h),

                        /// Promo + Button
                        Row(
                          children: [

                            /// Promo Field
                            Expanded(
                              child: Container(
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: isDark? Color(0xFF0F2D44):Color(0xffEAEDF1),
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isDark?Colors.black.withValues(alpha: 0.35):Color(0xff000000).withValues(alpha: 0.35),
                                      blurRadius: 8,
                                      spreadRadius: 0,

                                    ),
                                  ],

                                ),
                                child: TextField(
                                  onChanged: (value) =>
                                  ref.read(promoCodeProvider.notifier).state = value,
                                  style:  TextStyle(color: isDark?AppColors.textWhite:Colors.black),
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!.enterPromoCode,
                                    filled: true,
                                    fillColor: isDark?Color(0xff153250):Color(0xffEAEDF1),
                                    hintStyle:  TextStyle(color:AppColors.textGrey,),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color:isDark?Color(0xff153250):Color(0xffEAEDF1)),

                                    ),
                                    focusedBorder:OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color:isDark?Color(0xff153250):Color(0xffEAEDF1)),

                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color:isDark?Color(0xff153250):Color(0xffEAEDF1)),

                                    ),
                                    contentPadding:
                                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 12.w),

                            /// Apply Button
                            GestureDetector(
                              onTap: isApplying
                                  ? null
                                  : () async {
                                ref.read(isApplyingProvider.notifier).state = true;

                                await Future.delayed(
                                    const Duration(seconds: 2));

                                ref.read(isApplyingProvider.notifier).state = false;

                                 ref.read(paymentProvider.notifier ).applyCupon(context: context, code: promoCode, token: token);
                              },
                              child: Container(
                                height: 44.w,
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4F5BFF),
                                      Color(0xFF5E6BFF),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                alignment: Alignment.center,
                                child: isApplying
                                    ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                    : CustomText(
                                  text:
                                  AppLocalizations.of(context)!.apply,

                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,


                                ),
                              ),
                            ),


                          ],
                        ),


                      ],
                    ),
                  );
                },
                error:(error,stack)=>Center(child: CustomText(text: "No data found")),
                loading: ()=>PremiumCardShimmer(isDark: isDark,),
            ),

            SizedBox(height: 118.h,),

            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 24.w),
              child: Consumer(builder: (context, ref, child) {
                final isLoading = ref.read(paymentProvider.select((s)=>s.paymentLoading));
                return CustomPrimaryButton(onPressed: () async {
                  final result = await ref.read(paymentProvider.notifier).paymentFunction(context: context, token: token);
                  if(result){
                    context.go(RouteNames.loginScreen);

                  }



                  //context.go(RouteNames.getStartedScreen);
                },title: AppLocalizations.of(context)!.purchaseNow,isLoading: isLoading,);
              },),
            ),
            SizedBox(height: 10,),
            
            CustomText(text: AppLocalizations.of(context)!.purchasePlanToContinue,color: Color(0xff2DA8F0),fontSize: 16.sp,fontWeight: FontWeight.w400,)
          ],
        ),
      ),
    );
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