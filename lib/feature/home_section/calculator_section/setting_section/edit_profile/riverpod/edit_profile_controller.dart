import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/setting_section/edit_profile/data/model/get_me_profile_model.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/setting_section/edit_profile/data/repository/profile_repository.dart';

import 'edit_profile_state.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});


final getMeProvider = FutureProvider.autoDispose<GetMeModel>((ref) async {
  return await ref.watch(profileRepositoryProvider).getMeProfile();
});

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