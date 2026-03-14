
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/common/widgets/new_custon_widgets/app_snackbar.dart';
import '../../edit_profile/data/repository/profile_repository.dart';
import 'help_and_support_state.dart';



class HelpSupportNotifier extends StateNotifier<HelpSupportState> {
  HelpSupportNotifier() : super(HelpSupportState());

  void setScreenshot(File file) {
    state = state.copyWith(screenshot: file);
  }
  void setEmail(String value) {
    state = state.copyWith(email: value);
  }
  void setSubjectOfProblem(String value) {
    state = state.copyWith(subjectOrProblem: value);
  }

  void setProblemOfSuggestion(String value) {
    state = state.copyWith(problemOrSuggestion: value);
  }

  Future<void> pickImage( ref) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      ref.read(helpSupportProvider.notifier).setScreenshot(File(image.path));
    }
  }

  Future<bool> submitHelpAndSupport({required BuildContext context}) async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await ProfileRepository().updateHelpAndSupport(
          email: state.email,
        problem:  state.problemOrSuggestion,
        subject: state.subjectOrProblem,
        profilePicturePath: state.screenshot!.path.toString()
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

}

final helpSupportProvider =
StateNotifierProvider<HelpSupportNotifier, HelpSupportState>(
        (ref) => HelpSupportNotifier());