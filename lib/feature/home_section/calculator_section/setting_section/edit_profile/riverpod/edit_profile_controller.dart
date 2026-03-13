import 'dart:io';

import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

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

  void updateProfileImage(File image) {
    state = state.copyWith(profileImage: image);
  }

  Future<void> pickImage({required ref}) async {
    final picker = ImagePicker();

    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      ref
          .read(profileProvider.notifier)
          .updateProfileImage(File(pickedFile.path));
    }
  }
}

final profileProvider =
StateNotifierProvider<ProfileNotifier, ProfileState>(
        (ref) => ProfileNotifier());