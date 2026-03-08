
import 'dart:io';

import 'package:flutter_riverpod/legacy.dart';

class HelpSupportState {
  final File? screenshot;

  HelpSupportState({this.screenshot});

  HelpSupportState copyWith({File? screenshot}) {
    return HelpSupportState(
      screenshot: screenshot ?? this.screenshot,
    );
  }
}

class HelpSupportNotifier extends StateNotifier<HelpSupportState> {
  HelpSupportNotifier() : super(HelpSupportState());

  void setScreenshot(File file) {
    state = state.copyWith(screenshot: file);
  }
}

final helpSupportProvider =
StateNotifierProvider<HelpSupportNotifier, HelpSupportState>(
        (ref) => HelpSupportNotifier());