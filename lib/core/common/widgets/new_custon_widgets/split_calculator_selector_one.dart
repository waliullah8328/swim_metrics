import 'package:flutter/material.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import '../../../../../../core/utils/constants/app_colors.dart';

class SplitCalculatorSelectorOne extends StatefulWidget {
  final List<String> items;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const SplitCalculatorSelectorOne({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<SplitCalculatorSelectorOne> createState() =>
      _SplitCalculatorSelectorOneState();
}

class _SplitCalculatorSelectorOneState
    extends State<SplitCalculatorSelectorOne> {

  late FixedExtentScrollController _controller;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();

    selectedIndex = widget.items.indexOf(widget.selectedValue);
    if (selectedIndex == -1) selectedIndex = 0;

    _controller = FixedExtentScrollController(initialItem: selectedIndex);
    debugPrint(widget.selectedValue.toString());
  }

  @override
  void didUpdateWidget(covariant SplitCalculatorSelectorOne oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newIndex = widget.items.indexOf(widget.selectedValue);

    if (newIndex != -1 && newIndex != selectedIndex) {
      selectedIndex = newIndex;
      _controller.jumpToItem(newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double itemHeight = 55;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide( // ✅ Card grey border
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: (itemHeight * 3).h,
        child: Stack(
          alignment: Alignment.center,
          children: [

            /// Wheel
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
                childCount: widget.items.length,
                builder: (context, index) {

                  final isSelected = index == selectedIndex;

                  return Center(
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,

                      child: Text(
                        widget.items[index],
                        style: TextStyle(
                          fontSize: 19.sp,
                          color: isSelected ? Colors.amber : null,
                          fontWeight: isSelected
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            /// Center Highlight
            IgnorePointer(
              child: Container(
                height: itemHeight,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.textGrey,
                      width: 0.5,
                    ),
                    bottom: BorderSide(
                      color: AppColors.textGrey,
                      width: 0.5,
                    ),
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