import 'package:flutter/material.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/app_sizer.dart';


import '../../../../home_section/calculator_section/setting_section/settings/riverpod/setting_controller.dart';

/// LANGUAGE WHEEL SELECTOR
class LanguageWheelSelector extends StatefulWidget {
  final List<AppLanguage> items;
  final ValueChanged<AppLanguage> onChanged;
  final AppLanguage selectedLanguage;

  const LanguageWheelSelector({
    super.key,
    required this.items,
    required this.onChanged,
    required this.selectedLanguage,
  });

  @override
  State<LanguageWheelSelector> createState() => _LanguageWheelSelectorState();
}

class _LanguageWheelSelectorState extends State<LanguageWheelSelector> {
  late FixedExtentScrollController _controller;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.items.indexOf(widget.selectedLanguage);
    _controller = FixedExtentScrollController(initialItem: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    const double itemHeight = 70;

    return Container(
      height: (itemHeight * 3).h,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent),
        color: const Color(0xFF0B2E4A),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
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
                if (index < 0 || index >= widget.items.length) return null;

                final isSelected = index == selectedIndex;
                final lang = widget.items[index];

                return Center(
                  child: Text(
                    lang.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 19.sp,
                      color: isSelected ? Colors.amber : Colors.white70,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                );
              },
              childCount: widget.items.length,
            ),
          ),
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
    );
  }
}