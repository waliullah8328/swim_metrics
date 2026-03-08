import 'package:flutter/material.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import '../../../../../../../core/utils/constants/app_colors.dart';

class DistanceWheelSelector extends StatefulWidget {
  final List<int> items;
  final ValueChanged<int> onChanged;

  const DistanceWheelSelector({
    super.key,
    required this.items,
    required this.onChanged,
  });

  @override
  State<DistanceWheelSelector> createState() =>
      _DistanceWheelSelectorState();
}

class _DistanceWheelSelectorState extends State<DistanceWheelSelector> {
  final FixedExtentScrollController _controller =
  FixedExtentScrollController();

  int selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    const double itemHeight = 70;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: double.infinity, // take full width
        height: (itemHeight * 3).h,

        child: Stack(
          alignment: Alignment.center,
          children: [

            /// Scroll List
            ListWheelScrollView.useDelegate(
              controller: _controller,
              itemExtent: itemHeight,
              physics: const FixedExtentScrollPhysics(),
              perspective: 0.003,
              diameterRatio: 10,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
                widget.onChanged(widget.items[index]);
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  if (index < 0 || index >= widget.items.length) {
                    return null;
                  }

                  final isSelected = index == selectedIndex;

                  return Center(
                    child: Text(
                      widget.items[index].toString(),
                      style: TextStyle(
                        fontSize: 19.sp,
                        color: isSelected ? Colors.amber : isDark?AppColors.textWhite:Colors.black,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
                childCount: widget.items.length,
              ),
            ),

            /// Center Highlight Line
            IgnorePointer(
              child: Container(
                height: itemHeight,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.primary, width: 0.5),
                    bottom: BorderSide(color: AppColors.primary, width: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}