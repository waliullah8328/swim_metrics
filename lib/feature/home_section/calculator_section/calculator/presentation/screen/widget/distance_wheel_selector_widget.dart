import 'package:flutter/material.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import '../../../../../../../core/utils/constants/app_colors.dart';

class DistanceWheelSelector extends StatefulWidget {
  final List<int> items;
  final ValueChanged<int> onChanged;
  final int? selectedValue;

  const DistanceWheelSelector({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedValue,
  });

  @override
  State<DistanceWheelSelector> createState() =>
      _DistanceWheelSelectorState();
}

class _DistanceWheelSelectorState extends State<DistanceWheelSelector> {
  late FixedExtentScrollController _controller;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = _getInitialIndex();
    _controller = FixedExtentScrollController(initialItem: selectedIndex);
  }

  @override
  void didUpdateWidget(covariant DistanceWheelSelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newIndex = _getInitialIndex();

    if (newIndex != selectedIndex) {
      selectedIndex = newIndex;

      // ✅ FIX: delay scroll update to avoid Riverpod crash
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.jumpToItem(selectedIndex);
        }
      });
    }
  }

  int _getInitialIndex() {
    if (widget.selectedValue != null) {
      final idx = widget.items.indexOf(widget.selectedValue!);
      if (idx != -1) return idx;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    const double itemHeight = 70;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: double.infinity,
        height: (itemHeight * 3).h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ListWheelScrollView.useDelegate(
              controller: _controller,
              itemExtent: itemHeight,
              physics: const FixedExtentScrollPhysics(),
              perspective: 0.003,
              diameterRatio: 10,

              // ✅ FIXED (Riverpod-safe)
              onSelectedItemChanged: (index) {
                if (index == selectedIndex) return;

                setState(() {
                  selectedIndex = index;
                });

                // ✅ Delay provider update (IMPORTANT)
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    widget.onChanged(widget.items[index]);
                  }
                });
              },

              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  if (index < 0 || index >= widget.items.length) return null;

                  final isSelected = index == selectedIndex;

                  return Center(
                    child: Text(
                      widget.items[index].toString(),
                      style: TextStyle(
                        fontSize: 19.sp,
                        color: isSelected
                            ? Colors.amber
                            : isDark
                            ? AppColors.textWhite
                            : Colors.black,
                        fontWeight:
                        isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  );
                },
                childCount: widget.items.length,
              ),
            ),

            // ✅ Center highlight lines
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}