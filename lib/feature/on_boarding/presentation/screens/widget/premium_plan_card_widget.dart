import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/app_snackbar.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/sign_up_section/payment/presentation/screen/widget/premium_card_shimmer_widget.dart';
import '../../../../auth/sign_up_section/payment/river_pod/payment_controller.dart';

final promoCodeProvider = StateProvider<String>((ref) => '');
final isApplyingProvider = StateProvider<bool>((ref) => false);

class PremiumPlanCard extends ConsumerWidget {
  const PremiumPlanCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isApplying = ref.watch(isApplyingProvider);
    final payment = ref.watch(getPaymentProvider);

    return payment.when(
      data: (data) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF143B5A),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF2F6F9F),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
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
                    text: AppLocalizations.of(context)!.premium,
                    fontSize: 22.h,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFFC247),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        text: "\$${data.price}",
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFC247),
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: AppLocalizations.of(context)!.oneTimePay,
                        fontSize: 12.sp,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              /// Features Grid (FIXED)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.features?.length ?? 0,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 42, // ✅ FIX: stable height for text
                ),
                itemBuilder: (context, index) {
                  final feature = data.features![index];
                  return _FeatureItem(
                    text: feature.featureName.toString(),
                  );
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
                        color: const Color(0xFF0F2D44),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          ref.read(promoCodeProvider.notifier).state = value;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.enterPromoCode,
                          filled: true,
                          fillColor: const Color(0xff153250),
                          hintStyle: const TextStyle(color: Color(0xffE3D99B)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Color(0xff153250)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Color(0xff153250)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Color(0xff153250)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  /// Apply Button
                  GestureDetector(
                    onTap: isApplying
                        ? null
                        : () {
                      AppSnackBar.showSuccess(
                        context,
                        "This coupon is available only during the sign-up process.",
                      );
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
                        text: AppLocalizations.of(context)!.apply,
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
      error: (error, stack) =>
      const Center(child: CustomText(text: "No data found")),
      loading: () => PremiumCardShimmer(isDark: true),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;
  const _FeatureItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(IconPath.ticMarkIcon),
        SizedBox(width: 8.w),
        Expanded(
          child: CustomText(
            text: text,
            color: Colors.white,
            fontSize: 14.sp,
            maxLines: 2, // ✅ FIX: supports long text (Bangla)
          ),
        ),
      ],
    );
  }
}