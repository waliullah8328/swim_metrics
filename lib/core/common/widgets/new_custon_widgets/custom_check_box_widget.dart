import 'package:flutter/material.dart';

class CustomCheckBoxWidget extends StatelessWidget {
  const CustomCheckBoxWidget({
    super.key,
    this.value, this.onChanged,
  });



  final bool? value;
  final void Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4), // ✅ Rounded corners
          ),
          side: BorderSide(
            color: const Color(0xff7F27FF), // Border color
            width: 2, // Border thickness
          ),
          fillColor: WidgetStateProperty.resolveWith<Color>(
                (states) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xff7F27FF); // Checked color
              }
              return Colors.transparent; // Unchecked background
            },
          ),
          checkColor: WidgetStateProperty.all<Color>(Colors.white),
        ),
      ),
      child: Checkbox(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}