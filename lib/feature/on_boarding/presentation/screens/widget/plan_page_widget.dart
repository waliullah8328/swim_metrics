import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/feature/on_boarding/presentation/screens/widget/premium_plan_card_widget.dart';


class PlanPage extends ConsumerWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 60.h),
          Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text:
                "The Plan We Have",

                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,

              ),
            ),
          ),
          PremiumPlanCard(),
        ],
      ),
    );
  }
}