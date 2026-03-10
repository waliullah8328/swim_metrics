import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../../calculator_section/setting_section/settings/riverpod/setting_controller.dart';

class VerticalSelector extends ConsumerWidget {
  final List<String> items;
  final List<String> selected;
  final Function(String) onTap;

  const VerticalSelector({
    super.key,
    required this.items,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Height of each item
    const double itemHeight = 55;
    // Max number of visible items
    final visibleItems = items.length > 3 ? 3 : items.length;
    final settings = ref.watch(settingsProvider);
    final currentLanguageCode = settings.language.code;

    return Container(
      height: itemHeight * visibleItems, // fix container height
      decoration: BoxDecoration(
        color: isDark ?Color(0xff092541):Color(0xffEAEDF1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(width: 0.5.w,color: isDark?Color(0xff368ABB):Color(0xffEAEDF1))
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(items.length, (index) {
              final e = items[index];
              final isSelected = selected.contains(e);

              return GestureDetector(
                onTap: () => onTap(e),
                child: Container(
                  height: itemHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: index != items.length - 1
                        ? Border(

                      bottom: BorderSide(
                        width: 0.5.w,
                          color: isDark?Color(0xffC7C7C7):Color(0xffC7C7C7)),
                    )
                        : null, // no border for last item
                  ),
                  child: Text(
                    e,
                    style: TextStyle(
                      fontSize: currentLanguageCode.toString() != "en"?13:16.sp,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                      color: isSelected ? isDark?AppColors.textWhite:Color(0xff1c1f3a) : Colors.grey,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}