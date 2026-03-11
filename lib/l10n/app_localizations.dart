import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @textSize.
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get textSize;

  /// No description provided for @small.
  ///
  /// In en, this message translates to:
  /// **'SMALL'**
  String get small;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'MEDIUM'**
  String get medium;

  /// No description provided for @big.
  ///
  /// In en, this message translates to:
  /// **'BIG'**
  String get big;

  /// No description provided for @accessibility.
  ///
  /// In en, this message translates to:
  /// **'ACCESSIBILITY'**
  String get accessibility;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @stopWatchSound.
  ///
  /// In en, this message translates to:
  /// **'Stopwatch Sound'**
  String get stopWatchSound;

  /// No description provided for @voiceInput.
  ///
  /// In en, this message translates to:
  /// **'Voice Input'**
  String get voiceInput;

  /// No description provided for @hapticFeedBack.
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get hapticFeedBack;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'PERSONAL DETAILS'**
  String get personalDetails;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterYourPhoneNumber;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @securityDetails.
  ///
  /// In en, this message translates to:
  /// **'SECURITY DETAILS'**
  String get securityDetails;

  /// No description provided for @enterYourCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get enterYourCurrentPassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @enterYourNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get enterYourNewPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @enterYourConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your confirm password'**
  String get enterYourConfirmPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @savePassword.
  ///
  /// In en, this message translates to:
  /// **'Save Password'**
  String get savePassword;

  /// No description provided for @swimMetrics.
  ///
  /// In en, this message translates to:
  /// **'SwimMetrics'**
  String get swimMetrics;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 2.5'**
  String get version;

  /// No description provided for @manyThanksToMyFamilyAndFriends.
  ///
  /// In en, this message translates to:
  /// **'Many thanks to my family and friends.'**
  String get manyThanksToMyFamilyAndFriends;

  /// No description provided for @specialThanksToMyFriends.
  ///
  /// In en, this message translates to:
  /// **'Special thanks to my friends and mentors\n DCS, JCU, and ECR'**
  String get specialThanksToMyFriends;

  /// No description provided for @toolsExplain.
  ///
  /// In en, this message translates to:
  /// **'Tools Explained'**
  String get toolsExplain;

  /// No description provided for @splitCalculation.
  ///
  /// In en, this message translates to:
  /// **'Split calculation'**
  String get splitCalculation;

  /// No description provided for @courseConversion.
  ///
  /// In en, this message translates to:
  /// **'Course conversion'**
  String get courseConversion;

  /// No description provided for @stopWatch.
  ///
  /// In en, this message translates to:
  /// **'Stopwatch'**
  String get stopWatch;

  /// No description provided for @learning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get learning;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @ideasForUse.
  ///
  /// In en, this message translates to:
  /// **'Ideas for use'**
  String get ideasForUse;

  /// No description provided for @fags.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get fags;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @copyRight.
  ///
  /// In en, this message translates to:
  /// **'Copyright'**
  String get copyRight;

  /// No description provided for @fillUpTheInformation.
  ///
  /// In en, this message translates to:
  /// **'Fill up the Information'**
  String get fillUpTheInformation;

  /// No description provided for @subjectOfProblemOrSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Subject of Problem or Suggestion'**
  String get subjectOfProblemOrSuggestion;

  /// No description provided for @problemOrSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Problem or Suggestion'**
  String get problemOrSuggestion;

  /// No description provided for @screenshotOptional.
  ///
  /// In en, this message translates to:
  /// **'Screenshot (Optional)'**
  String get screenshotOptional;

  /// No description provided for @tapToAddAScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Tap to add a screenshot'**
  String get tapToAddAScreenshot;

  /// No description provided for @jPGPNGFileFormats.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG File Formats'**
  String get jPGPNGFileFormats;

  /// No description provided for @typeHere.
  ///
  /// In en, this message translates to:
  /// **'Type here'**
  String get typeHere;

  /// No description provided for @calculator.
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get calculator;

  /// No description provided for @converter.
  ///
  /// In en, this message translates to:
  /// **'Converter'**
  String get converter;

  /// No description provided for @splitCalculator.
  ///
  /// In en, this message translates to:
  /// **'Split Calculator'**
  String get splitCalculator;

  /// No description provided for @pullDownToSeeOptions.
  ///
  /// In en, this message translates to:
  /// **'Pull Down To See Options'**
  String get pullDownToSeeOptions;

  /// No description provided for @course.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get course;

  /// No description provided for @scy.
  ///
  /// In en, this message translates to:
  /// **'SCY'**
  String get scy;

  /// No description provided for @scm.
  ///
  /// In en, this message translates to:
  /// **'SCM'**
  String get scm;

  /// No description provided for @lcm.
  ///
  /// In en, this message translates to:
  /// **'LCM'**
  String get lcm;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'GENDER'**
  String get gender;

  /// No description provided for @men.
  ///
  /// In en, this message translates to:
  /// **'Men'**
  String get men;

  /// No description provided for @women.
  ///
  /// In en, this message translates to:
  /// **'Women'**
  String get women;

  /// No description provided for @stroke.
  ///
  /// In en, this message translates to:
  /// **'STROKE'**
  String get stroke;

  /// No description provided for @fly.
  ///
  /// In en, this message translates to:
  /// **'Fly'**
  String get fly;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @breast.
  ///
  /// In en, this message translates to:
  /// **'Breast'**
  String get breast;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @im.
  ///
  /// In en, this message translates to:
  /// **'IM'**
  String get im;

  /// No description provided for @dist.
  ///
  /// In en, this message translates to:
  /// **'DIST'**
  String get dist;

  /// No description provided for @goalTime.
  ///
  /// In en, this message translates to:
  /// **'GOAL TIME'**
  String get goalTime;

  /// No description provided for @enterYourTime.
  ///
  /// In en, this message translates to:
  /// **'Enter your time'**
  String get enterYourTime;

  /// No description provided for @calculateSplit.
  ///
  /// In en, this message translates to:
  /// **'Calculate Split'**
  String get calculateSplit;

  /// No description provided for @split.
  ///
  /// In en, this message translates to:
  /// **'SPLIT'**
  String get split;

  /// No description provided for @splitTime.
  ///
  /// In en, this message translates to:
  /// **'SPLIT TIME'**
  String get splitTime;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get total;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @noSplitsYet.
  ///
  /// In en, this message translates to:
  /// **'No splits yet'**
  String get noSplitsYet;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'NORMAL'**
  String get normal;

  /// No description provided for @predictor.
  ///
  /// In en, this message translates to:
  /// **'PREDICTOR'**
  String get predictor;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'MODE'**
  String get mode;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get start;

  /// No description provided for @undoSplit.
  ///
  /// In en, this message translates to:
  /// **'UNDO SPLIT'**
  String get undoSplit;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'STOP'**
  String get stop;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'RESUME'**
  String get resume;

  /// No description provided for @clearTime.
  ///
  /// In en, this message translates to:
  /// **'CLEAR TIME'**
  String get clearTime;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'FROM'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'TO'**
  String get to;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'DISTANCE'**
  String get distance;

  /// No description provided for @splitSize.
  ///
  /// In en, this message translates to:
  /// **'SPLIT SIZE'**
  String get splitSize;

  /// No description provided for @startType.
  ///
  /// In en, this message translates to:
  /// **'START TYPE'**
  String get startType;

  /// No description provided for @fromStart.
  ///
  /// In en, this message translates to:
  /// **'FROM START'**
  String get fromStart;

  /// No description provided for @fromMiddle.
  ///
  /// In en, this message translates to:
  /// **'FROM MIDDLE'**
  String get fromMiddle;

  /// No description provided for @fromLast.
  ///
  /// In en, this message translates to:
  /// **'FROM LAST'**
  String get fromLast;

  /// No description provided for @multipleCourses.
  ///
  /// In en, this message translates to:
  /// **'MULTIPLE COURSES'**
  String get multipleCourses;

  /// No description provided for @convertTime.
  ///
  /// In en, this message translates to:
  /// **'Convert Time'**
  String get convertTime;

  /// No description provided for @convertedTime.
  ///
  /// In en, this message translates to:
  /// **'CONVERTED TIME'**
  String get convertedTime;

  /// No description provided for @tapTimeToShowSplits.
  ///
  /// In en, this message translates to:
  /// **'Tap time to show splits'**
  String get tapTimeToShowSplits;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password?'**
  String get forgetPassword;

  /// No description provided for @donNotHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account?'**
  String get donNotHaveAnAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @doNotWorryPleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry! Please enter the email address linked with your account.'**
  String get doNotWorryPleaseEnterYourEmail;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyYourEmail;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips: Make sure check your inbox and spam folders'**
  String get tips;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @verifiedEmail.
  ///
  /// In en, this message translates to:
  /// **'Verified Email !'**
  String get verifiedEmail;

  /// No description provided for @yourAccountHasBeenCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your Account has been created successfully.'**
  String get yourAccountHasBeenCreatedSuccessfully;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create new password'**
  String get createNewPassword;

  /// No description provided for @yourNewPasswordMustBeUnique.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be unique from those previously used.'**
  String get yourNewPasswordMustBeUnique;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password Changed !'**
  String get passwordChanged;

  /// No description provided for @yourPasswordHasBeenChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed successfully.'**
  String get yourPasswordHasBeenChangedSuccessfully;

  /// No description provided for @continue1.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue1;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back To Login'**
  String get backToLogin;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create An Account'**
  String get createAnAccount;

  /// No description provided for @iAgreeTo.
  ///
  /// In en, this message translates to:
  /// **'I agree to'**
  String get iAgreeTo;

  /// No description provided for @termsAndPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Terms and Privacy Policy.'**
  String get termsAndPrivacyPolicy;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @converterBig.
  ///
  /// In en, this message translates to:
  /// **'CONVERTER'**
  String get converterBig;

  /// No description provided for @paymentScreen.
  ///
  /// In en, this message translates to:
  /// **'Payment Screen'**
  String get paymentScreen;

  /// No description provided for @thePlanWeHave.
  ///
  /// In en, this message translates to:
  /// **'The Plan We Have'**
  String get thePlanWeHave;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @oneTimePay.
  ///
  /// In en, this message translates to:
  /// **'One Time Pay'**
  String get oneTimePay;

  /// No description provided for @enterPromoCode.
  ///
  /// In en, this message translates to:
  /// **'Enter promo code'**
  String get enterPromoCode;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @purchaseNow.
  ///
  /// In en, this message translates to:
  /// **'Purchase Now'**
  String get purchaseNow;

  /// No description provided for @purchasePlanToContinue.
  ///
  /// In en, this message translates to:
  /// **'Purchase plan to continue'**
  String get purchasePlanToContinue;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
