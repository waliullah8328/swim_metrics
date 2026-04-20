import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Import Riverpod
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../setting_section/settings/riverpod/setting_controller.dart';

class SplitCalculatorSelector extends ConsumerStatefulWidget { // 2. Change to ConsumerStatefulWidget
  final List<String> items;
  final String selectedValue;
  final ValueChanged<String> onChanged;


  const SplitCalculatorSelector({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,

  });

  @override
  ConsumerState<SplitCalculatorSelector> createState() => // 3. Return ConsumerState
  _SplitCalculatorSelectorState();
}

class _SplitCalculatorSelectorState extends ConsumerState<SplitCalculatorSelector> { // 4. Extend ConsumerState
  late FixedExtentScrollController _controller;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    // You can access 'ref' here if needed, e.g., ref.read(provider)
    selectedIndex = widget.items.indexOf(widget.selectedValue);
    if (selectedIndex == -1) selectedIndex = 0;
    _controller = FixedExtentScrollController(initialItem: selectedIndex);
  }

  @override
  void didUpdateWidget(covariant SplitCalculatorSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newIndex = widget.items.indexOf(widget.selectedValue);
    if (newIndex != -1 && newIndex != selectedIndex) {
      selectedIndex = newIndex;
      _controller.jumpToItem(newIndex);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // You can now access 'ref' directly here
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const double itemHeight = 70;
    final isHaptic = ref.watch(settingsProvider.select((s) => s.haptic));

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
            /// Wheel
            ListWheelScrollView.useDelegate(
              controller: _controller,
              itemExtent: itemHeight,
              physics: const FixedExtentScrollPhysics(),
              perspective: 0.003,
              diameterRatio: 10,
              onSelectedItemChanged: (index) {
                if (isHaptic) HapticFeedback.heavyImpact();

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
                    child: Text(
                      widget.items[index],
                      style: TextStyle(
                        fontSize: 19.sp,
                        color: isSelected
                            ? (isDark ? Colors.amber : const Color(0xFFB38F2E))
                            : null,
                        fontWeight:
                        isSelected ? FontWeight.w500 : FontWeight.normal,
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
                      color: AppColors.primary,
                      width: 0.5,
                    ),
                    bottom: BorderSide(
                      color: AppColors.primary,
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