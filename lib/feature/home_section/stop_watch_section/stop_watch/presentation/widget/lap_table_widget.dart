import 'package:flutter/material.dart';

class LapTable extends StatelessWidget {
  final List<Duration> laps;

  const LapTable({super.key, required this.laps});

  String format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final ms =
    (d.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');

    return "$m:$s.$ms";
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: laps.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Lap ${index + 1}"),
          trailing: Text(format(laps[index])),
        );
      },
    );
  }
}