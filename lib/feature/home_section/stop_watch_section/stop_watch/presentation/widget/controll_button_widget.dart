import 'package:flutter/material.dart';

class ControlButtons extends StatelessWidget {
  final bool running;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final VoidCallback onLap;

  const ControlButtons({
    super.key,
    required this.running,
    required this.onStart,
    required this.onPause,
    required this.onReset,
    required this.onLap,
  });

  @override
  Widget build(BuildContext context) {

    /// START BUTTON
    if (!running) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffc49a3a),
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: onStart,
        child: const Text("START"),
      );
    }

    /// RUNNING STATE
    return Column(
      children: [

        /// LAP BUTTON
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            minimumSize: const Size(double.infinity, 45),
          ),
          onPressed: onLap,
          child: const Text("LAP"),
        ),

        const SizedBox(height: 10),

        Row(
          children: [

            /// PAUSE
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                onPressed: onPause,
                child: const Text("PAUSE"),
              ),
            ),

            const SizedBox(width: 10),

            /// STOP / RESET
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: onReset,
                child: const Text("STOP"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}