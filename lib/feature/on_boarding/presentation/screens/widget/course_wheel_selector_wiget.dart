import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';
import '../../../../../core/utils/constants/app_colors.dart';

class CourseWheelSelector extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String> onChanged;

  const CourseWheelSelector({
    super.key,
    required this.items,
    required this.onChanged,
  });

  @override
  State<CourseWheelSelector> createState() => _CourseWheelSelectorState();
}

class _CourseWheelSelectorState extends State<CourseWheelSelector> {
  late FixedExtentScrollController _controller;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    /// start from first item
    _controller = FixedExtentScrollController(initialItem: selectedIndex);

    /// return first value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged(widget.items[selectedIndex]);
    });
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
          /// Wheel List
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

                /// Dynamic numbering based on selected index
                int displayNumber = (index - selectedIndex).abs() + 1;

                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 24.w, right: 24.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Number
                        Text(
                          "$displayNumber.",
                          style: TextStyle(
                            fontSize: 19.sp,
                            color:
                            isSelected ? Colors.amber : Colors.white70,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),

                        /// Course Name
                        Text(
                          widget.items[index],
                          style: TextStyle(
                            fontSize: 18.sp,
                            color:
                            isSelected ? Colors.amber : Colors.white70,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),

                        /// Icon
                        SvgPicture.asset(
                          IconPath.courseIcon,
                          height: 20.h,
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: widget.items.length,
            ),
          ),

          /// Center highlight
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
    );
  }
}