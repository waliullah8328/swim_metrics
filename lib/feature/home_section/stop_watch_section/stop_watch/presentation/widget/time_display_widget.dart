import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final Duration duration;

  const TimerDisplay({super.key, required this.duration});

  String format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final millis =
    (d.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');

    return "$minutes:$seconds.$millis";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          format(duration),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}