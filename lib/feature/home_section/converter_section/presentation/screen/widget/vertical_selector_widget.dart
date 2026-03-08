import 'package:flutter/material.dart';

class VerticalSelector extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // Height of each item
    const double itemHeight = 55;
    // Max number of visible items
    final visibleItems = items.length > 3 ? 3 : items.length;

    return Container(
      height: itemHeight * visibleItems, // fix container height
      decoration: BoxDecoration(
        color: const Color(0xffd9dbe1),
        borderRadius: BorderRadius.circular(18),
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
                      bottom: BorderSide(color: Colors.grey.shade300),
                    )
                        : null, // no border for last item
                  ),
                  child: Text(
                    e,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                      color: isSelected ? const Color(0xff1c1f3a) : Colors.grey,
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