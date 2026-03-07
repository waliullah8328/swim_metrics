import 'package:flutter/material.dart';

class StopwatchPage extends StatelessWidget {
  const StopwatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Stopwatch Screen",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}