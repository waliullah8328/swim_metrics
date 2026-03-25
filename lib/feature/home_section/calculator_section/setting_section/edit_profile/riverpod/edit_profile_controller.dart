import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/app_snackbar.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/setting_section/edit_profile/data/model/get_me_profile_model.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/setting_section/edit_profile/data/repository/profile_repository.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import 'edit_profile_state.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});


final getMeProvider = FutureProvider.autoDispose<GetMeModel>((ref) async {
  return await ref.watch(profileRepositoryProvider).getMeProfile();
});

class ProfileNotifier extends StateNotifier<ProfileState> {
  final Ref ref;
  ProfileNotifier(this.ref) : super(ProfileState()){

      // Fetch data on init
      _loadProfile();

  }



  Future<void> _loadProfile() async {
    final profileAsync = await ref.read(getMeProvider.future);

    state = state.copyWith(
      name: profileAsync.name,
      email: profileAsync.email,
      phone: profileAsync.phone
    );
  }

  void updateName(String value) {
    state = state.copyWith(name: value);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updatePhone(String value) {
    state = state.copyWith(phone: value);
  }

  void updateCurrentPassword(String value) {
    state = state.copyWith(currentPassword: value);
  }
  void updateNewPassword(String value) {
    state = state.copyWith(newPassword: value);
  }
  void updateConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value);
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

  Future<bool> saveProfile({required BuildContext context}) async {
    if(state.phone.isEmpty){
      AppSnackBar.showError(context,  AppLocalizations.of(context)!.pleaseEnterYourPhoneNumber);

    }
    if (state.profileImage == null) {
      AppSnackBar.showError(context, AppLocalizations.of(context)!.pleaseSelectAProfileImage);
      return false;
    }
    state = state.copyWith(isLoading: true);

    try {
      final response = await ProfileRepository().updateProfile(
          email: state.email,
          name: state.name,
          phoneNumber: state.phone,
          profilePicturePath: state.profileImage!.path.toString()
      );

      if (response['success'] == true) {
        state = state.copyWith(isLoading: false,  );
        AppSnackBar.showSuccess(context, response['message']);

        return true;
      } else {
        final error = response['error'] ?? response['message'];
        state = state.copyWith(isLoading: false, );
        AppSnackBar.showError(context, error);

        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false,);
      AppSnackBar.showError(context, e.toString());
      return false;
    }
  }


  Future<bool> changePassword({required BuildContext context}) async {



    state = state.copyWith(isPasswordLoading: true, );

    try {
      final response = await ProfileRepository().changePassword(
          oldPassword: state.currentPassword,
          newPassword: state.newPassword
      );

      debugPrint("Signup response: $response");


      if (response['success'] == true) {
        state = state.copyWith(isPasswordLoading: false,);

        AppSnackBar.showSuccess(context,  response['message']);





        return true;
      } else {
        // Handle specific error messages from the API
        final error = response['error'] ?? response['message'];
        AppSnackBar.showError(context,  error);


        state = state.copyWith(isPasswordLoading: false);

        // Notify UI of error
        return false;
      }
    } catch (e) {
      debugPrint("Signup exception: $e");
      AppSnackBar.showError(context,  e.toString());

      state = state.copyWith(isPasswordLoading: false);
      // Notify UI of exception
      return false;
    }


  }



}

final profileProvider =
StateNotifierProvider<ProfileNotifier, ProfileState>(
        (ref) => ProfileNotifier(ref));