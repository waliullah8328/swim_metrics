import 'package:flutter_riverpod/legacy.dart';

import 'edit_profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState());

  void updateName(String value) {
    state = state.copyWith(name: value);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updatePhone(String value) {
    state = state.copyWith(phone: value);
  }
}

final profileProvider =
StateNotifierProvider<ProfileNotifier, ProfileState>(
        (ref) => ProfileNotifier());