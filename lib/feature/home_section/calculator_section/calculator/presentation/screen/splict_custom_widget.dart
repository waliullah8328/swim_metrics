import 'package:flutter/material.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

class SplitCalculatorSelector extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String> onChanged;

  const SplitCalculatorSelector({
    super.key,
    required this.items,
    required this.onChanged,
  });

  @override
  State<SplitCalculatorSelector> createState() =>
      _SplitCalculatorSelectorState();
}

class _SplitCalculatorSelectorState
    extends State<SplitCalculatorSelector> {
  final FixedExtentScrollController _controller =
  FixedExtentScrollController();

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const double itemHeight = 70;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 40),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),

      ),
      child: SizedBox(
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
                      widget.items[index],
                      style: TextStyle(
                        fontSize: 19.sp,
                        color: isSelected
                            ? Colors.amber
                            : null,
                        fontWeight:
                        isSelected ? FontWeight.w500 : FontWeight.normal,
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