import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for Haptics
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../feature/home_section/calculator_section/setting_section/settings/riverpod/setting_controller.dart';

class SplitCalculatorSelectorOne extends ConsumerStatefulWidget {
  final List<String> items;
  final String selectedValue;
  final ValueChanged<String> onChanged;
  final bool isHaptic; // Toggle for haptics

  const SplitCalculatorSelectorOne({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.isHaptic = true,
  });

  @override
  ConsumerState<SplitCalculatorSelectorOne> createState() =>
      _SplitCalculatorSelectorOneState();
}

class _SplitCalculatorSelectorOneState
    extends ConsumerState<SplitCalculatorSelectorOne> {
  late FixedExtentScrollController _controller;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();

    // Initialize index based on the passed value
    selectedIndex = widget.items.indexOf(widget.selectedValue);
    if (selectedIndex == -1) selectedIndex = 0;

    _controller = FixedExtentScrollController(initialItem: selectedIndex);
  }

  @override
  void didUpdateWidget(covariant SplitCalculatorSelectorOne oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newIndex = widget.items.indexOf(widget.selectedValue);

    if (newIndex != -1 && newIndex != selectedIndex) {
      selectedIndex = newIndex;

      // ✅ FIX: Avoid "Build phase" exceptions by jumping after the frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller.hasClients) {
          _controller.jumpToItem(newIndex);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can now access 'ref' here to watch other providers if needed
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const double itemHeight = 55;
    final isHaptic = ref.watch(settingsProvider.select((s) => s.haptic));

    return Card(
      elevation: 0,
      color: Colors.transparent, // Adjusting based on your manual Card shape
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.grey.shade800 : const Color(0xffEAEDF1),
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
                if (index == selectedIndex) return;

                // 📳 Haptic Feedback
                if (isHaptic) HapticFeedback.heavyImpact();

                setState(() {
                  selectedIndex = index;
                });

                // ✅ RIVERPOD SAFE: delay update to avoid state-mutation errors during build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    widget.onChanged(widget.items[index]);
                  }
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: widget.items.length,
                builder: (context, index) {
                  final isSelected = index == selectedIndex;

                  return Center(
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: CustomText(
                        text: widget.items[index],
                        fontSize: 19.sp,
                        color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : Colors.black54),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),

            /// Center Highlight Overlay
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}