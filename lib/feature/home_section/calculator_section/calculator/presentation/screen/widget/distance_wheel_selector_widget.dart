import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Added Riverpod import
import 'package:google_fonts/google_fonts.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../setting_section/settings/riverpod/setting_controller.dart';

class DistanceWheelSelector extends ConsumerStatefulWidget { // 2. Changed to ConsumerStatefulWidget
  final List<int> items;
  final ValueChanged<int> onChanged;
  final int? selectedValue;
  final bool isHaptic; // Optional haptic toggle

  const DistanceWheelSelector({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedValue,
    this.isHaptic = true,
  });

  @override
  ConsumerState<DistanceWheelSelector> createState() => // 3. Changed to ConsumerState
  _DistanceWheelSelectorState();
}

class _DistanceWheelSelectorState extends ConsumerState<DistanceWheelSelector> { // 4. Changed to ConsumerState
  late FixedExtentScrollController _controller;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // You can access 'ref' here if needed
    selectedIndex = _getInitialIndex();

    _controller = FixedExtentScrollController(
      initialItem: selectedIndex,
    );
  }

  @override
  void didUpdateWidget(covariant DistanceWheelSelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newIndex = _getInitialIndex();

    /// ✅ Only update if actually changed
    if (newIndex != selectedIndex) {
      selectedIndex = newIndex;

      /// 🔥 SMOOTH instead of jump
      _controller.animateToItem(
        selectedIndex,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
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
    // You can access 'ref' here to watch providers
    const double itemHeight = 70;
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            ListWheelScrollView.useDelegate(
              controller: _controller,
              itemExtent: itemHeight,
              physics: const FixedExtentScrollPhysics(),
              perspective: 0.003,
              diameterRatio: 10,

              /// ✅ CLEAN (no postFrame, no lag)
              onSelectedItemChanged: (index) {
                if (index == selectedIndex) return;

                // 📳 Haptic Feedback Trigger
                if (widget.isHaptic) {
                  HapticFeedback.mediumImpact();
                }

                setState(() {
                  selectedIndex = index;
                });

                widget.onChanged(widget.items[index]);
                if (isHaptic) HapticFeedback.heavyImpact();
              },

              childDelegate: ListWheelChildBuilderDelegate(
                childCount: widget.items.length,
                builder: (context, index) {
                  final isSelected = index == selectedIndex;

                  return Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: GoogleFonts.merriweather(
                        fontSize: isSelected ? 20.sp : 16.sp,
                        color: isSelected
                            ? (isDark ? Colors.amber : const Color(0xFFB38F2E))
                            : (isDark ? Colors.white : Colors.black),
                        fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      child: Text(widget.items[index].toString()),
                    ),
                  );
                },
              ),
            ),

            /// ✅ Center highlight
            IgnorePointer(
              child: Container(
                height: itemHeight,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: AppColors.primary, width: 0.6),
                    bottom: BorderSide(
                        color: AppColors.primary, width: 0.6),
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