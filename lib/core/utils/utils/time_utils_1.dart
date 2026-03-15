class TimeUtils1 {
  static double parseToSeconds(String input) {
    final s = input.trim();
    if (s.contains(':')) {
      final parts = s.split(':');
      final m = double.parse(parts[0]);
      final sec = double.parse(parts[1]);
      return m * 60 + sec;
    }
    return double.parse(s);
  }

  static String formatSeconds(double seconds) {
    if (seconds < 60) {
      return seconds.toStringAsFixed(2);
    }
    final m = seconds ~/ 60;
    final sec = seconds % 60;
    return '$m:${sec.toStringAsFixed(2).padLeft(5, '0')}';
  }
}
