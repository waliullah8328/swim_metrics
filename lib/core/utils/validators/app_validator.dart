import '../../../l10n/app_localizations.dart';

class AppValidator {
  AppValidator._();

  static String? validateEmail(String? value,context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emailIsRequired;
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return AppLocalizations.of(context)!.invalidEmailAddress;
    }

    return null;
  }

  static String? validatePassword(String? value,context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.passwordIsRequired;
    }

    // Check for minimum password length
    if (value.length < 6) {
      return AppLocalizations.of(context)!.passwordMustBe;
    }
// Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return AppLocalizations.of(context)!.passwordMustContainUpperCaseLetter;
    }

// Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return AppLocalizations.of(context)!.passwordMustContainOneNumber;
    }

// Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return AppLocalizations.of(context)!.passwordMustContainSpacialCharacter;
    }
    return null;

  }

  static String? validateConfirmPassword(String? value,String password,context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.passwordIsRequired;
    }

    // Check for minimum password length
    if (value.length < 6) {
      return AppLocalizations.of(context)!.passwordMustBe;
    }
// Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return AppLocalizations.of(context)!.passwordMustContainUpperCaseLetter;
    }

// Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return AppLocalizations.of(context)!.passwordMustContainOneNumber;
    }

// Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return AppLocalizations.of(context)!.passwordMustContainSpacialCharacter;
    }

    if(value != password){
      return AppLocalizations.of(context)!.passwordDoesNotMatch;

    }
    return null;

  }
  static String? validatePhoneNumber(String? value,context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.phoneNumberIsRequired;
    }

    // Regular expression for phone number validation (assuming a 10-digit US phone number format)
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return AppLocalizations.of(context)!.invalidPhoneNumber;
    }

    return null;
  }

  static String? validateName(String? value,context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.nameIsRequired;
    }



    return null;
  }

  static String? validateSubjectOfProblem(String? value,context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.subjectOfProblemIsRequired;
    }



    return null;
  }

  static String? validateProblemOrSuggestion(String? value,context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.problemOrSuggestion;
    }



    return null;
  }


}
