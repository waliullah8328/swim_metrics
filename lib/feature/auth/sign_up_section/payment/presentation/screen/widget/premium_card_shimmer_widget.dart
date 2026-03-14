import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

class PremiumCardShimmer extends StatelessWidget {
  final bool isDark;
  const PremiumCardShimmer({super.key, required this.isDark});

  Widget shimmerBox({double? width, double? height, double radius = 6}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2F6F9F) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : const Color(0xff000000).withValues(alpha: 0.15),
              blurRadius: 8,
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
                shimmerBox(width: 120.w, height: 22.h),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    shimmerBox(width: 60.w, height: 26.h),
                    SizedBox(height: 6.h),
                    shimmerBox(width: 80.w, height: 12.h),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20.h),

            /// Features Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 4,
              ),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    shimmerBox(width: 14, height: 14),
                    SizedBox(width: 8.w),
                    shimmerBox(width: 100.w, height: 14.h),
                  ],
                );
              },
            ),

            SizedBox(height: 20.h),

            /// Promo + Button
            Row(
              children: [
                Expanded(
                  child: shimmerBox(height: 48.h),
                ),
                SizedBox(width: 12.w),
                shimmerBox(width: 90.w, height: 44.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}