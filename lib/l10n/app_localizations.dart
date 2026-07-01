import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en'),
  ];

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get language;

  /// App name
  ///
  /// In en, this message translates to:
  /// **'Drip Talk'**
  String get appName;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @loadingSubmit.
  ///
  /// In en, this message translates to:
  /// **'Creating Account...'**
  String get loadingSubmit;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code? '**
  String get didntReceiveCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resend;

  /// No description provided for @orText.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orText;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'OR Continue With'**
  String get orContinueWith;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loginTwoFactorTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify 2FA'**
  String get loginTwoFactorTitle;

  /// No description provided for @loginTwoFactorScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter The 6-Digit Code'**
  String get loginTwoFactorScreenTitle;

  /// No description provided for @loginTwoFactorScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open your authenticator app and enter the verification code to finish signing in.'**
  String get loginTwoFactorScreenSubtitle;

  /// No description provided for @loginTwoFactorAction.
  ///
  /// In en, this message translates to:
  /// **'Verify & Sign In'**
  String get loginTwoFactorAction;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter otp'**
  String get enterOtp;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @youHaveSignedUpSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'You have Signed up successfully'**
  String get youHaveSignedUpSuccessfully;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login Successfully '**
  String get loginSuccess;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You have successfully signed in to your account.'**
  String get congratulations;

  /// No description provided for @resetPasswordDes.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from the previous one.'**
  String get resetPasswordDes;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @minimum8Characters.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters in length'**
  String get minimum8Characters;

  /// No description provided for @atLeastOneNumber.
  ///
  /// In en, this message translates to:
  /// **'At least one special character (e.g., ! @)'**
  String get atLeastOneNumber;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Drip Talk'**
  String get welcome;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading experience...'**
  String get loading;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging In...'**
  String get loggingIn;

  /// No description provided for @loginDes.
  ///
  /// In en, this message translates to:
  /// **'Login to dripTalk'**
  String get loginDes;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we’ll send you a reset link to recover your DripTalk account.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get sendVerificationCode;

  /// No description provided for @changePasswordVerificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We’ll send a verification code to your email before you update your password.'**
  String get changePasswordVerificationSubtitle;

  /// No description provided for @changePasswordVerificationSentDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your email to continue changing your password.'**
  String get changePasswordVerificationSentDescription;

  /// No description provided for @rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get rememberPassword;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to continue'**
  String get loginSubtitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create Your DripTalk Account'**
  String get signupSubtitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join the future of AI-powered fashion'**
  String get createAccountSubtitle;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already Have An Account?'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t Have An Account?'**
  String get dontHaveAccount;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get checkYourEmail;

  /// No description provided for @resettingYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit code sent to your email to continue resetting your password.'**
  String get resettingYourPassword;

  /// Description shown on the OTP screen when verifying a new account signup
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your email to verify your account and continue.'**
  String get otpDescriptionSignup;

  /// Description shown on the OTP screen for forgot password verification
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your email to continue resetting your password.'**
  String get otpDescriptionForgotPassword;

  /// Description shown on the OTP screen when two-factor authentication is required during login
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your email to complete your sign in securely.'**
  String get otpDescriptionTwoFactor;

  /// Loading label shown on the verify button while the OTP is being verified
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get otpVerifying;

  /// Success toast shown after OTP verification succeeds
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully'**
  String get otpVerifiedSuccess;

  /// Success toast shown after resending an OTP code
  ///
  /// In en, this message translates to:
  /// **'OTP resent successfully'**
  String get otpResentSuccess;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get invalidPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @loadingPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get loadingPleaseWait;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @secureReliable.
  ///
  /// In en, this message translates to:
  /// **'Secure • Fast • Reliable'**
  String get secureReliable;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @splashTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover Conversations with Drip Talk AI Powered Talk at Your Fingertips'**
  String get splashTitle;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'ai-powered personal styling,tailored for you'**
  String get onboardingWelcome;

  /// No description provided for @onboardingMatch.
  ///
  /// In en, this message translates to:
  /// **'Find Your Perfect Conversation Match with Drip Talk’s Personalized AI!'**
  String get onboardingMatch;

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

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email:'**
  String get enterYourEmail;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name:'**
  String get enterYourName;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password:'**
  String get enterYourPassword;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password:'**
  String get confirmYourPassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @loginDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your fashion journey'**
  String get loginDescription;

  /// No description provided for @signupDescription.
  ///
  /// In en, this message translates to:
  /// **'Join Drip Talk and unlock AI-powered conversations tailored just for you.'**
  String get signupDescription;

  /// No description provided for @featureOneTitle.
  ///
  /// In en, this message translates to:
  /// **'Instant Conversations'**
  String get featureOneTitle;

  /// No description provided for @featureOneDescription.
  ///
  /// In en, this message translates to:
  /// **'Personalized outfit recommendations based on your style, body type, and mood powered by AI.'**
  String get featureOneDescription;

  /// No description provided for @featureTwoTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover the Latest Fashion Trends and Styles'**
  String get featureTwoTitle;

  /// No description provided for @featureTwoDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore trending outfits, streetwear looks, and curated fashion collections powered by AI.'**
  String get featureTwoDescription;

  /// No description provided for @featureThreeTitle.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Fashion Advice and Styling Tips'**
  String get featureThreeTitle;

  /// No description provided for @featureThreeDescription.
  ///
  /// In en, this message translates to:
  /// **'Chat with DripTalk AI for instant fashion advice, styling tips, and drip checks.'**
  String get featureThreeDescription;

  /// No description provided for @continueWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get continueWithFacebook;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password Reset Successfully'**
  String get passwordResetSuccess;

  /// No description provided for @youCanNowLogin.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated. You can now log in to DripTalk with your new password.'**
  String get youCanNowLogin;

  /// No description provided for @changePasswordProfileSuccessDescription.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated successfully.'**
  String get changePasswordProfileSuccessDescription;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get createNewPassword;

  /// No description provided for @createNewPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a strong password to protect your account.'**
  String get createNewPasswordSubtitle;

  /// No description provided for @changePasswordScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Your Password'**
  String get changePasswordScreenTitle;

  /// No description provided for @changePasswordScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your account secure by updating your password regularly.'**
  String get changePasswordScreenSubtitle;

  /// No description provided for @changePasswordNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a strong new password'**
  String get changePasswordNewPasswordHint;

  /// No description provided for @changePasswordConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your new password'**
  String get changePasswordConfirmPasswordHint;

  /// No description provided for @changePasswordRequirementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Must Include:'**
  String get changePasswordRequirementsTitle;

  /// No description provided for @changePasswordRuleMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get changePasswordRuleMinLength;

  /// No description provided for @changePasswordRuleUppercase.
  ///
  /// In en, this message translates to:
  /// **'One uppercase letter'**
  String get changePasswordRuleUppercase;

  /// No description provided for @changePasswordRuleNumberOrSymbol.
  ///
  /// In en, this message translates to:
  /// **'One number or symbol'**
  String get changePasswordRuleNumberOrSymbol;

  /// No description provided for @changePasswordRuleSpecialCharacter.
  ///
  /// In en, this message translates to:
  /// **'Includes a special character (e.g. @, #, \$)'**
  String get changePasswordRuleSpecialCharacter;

  /// No description provided for @changePasswordUpdateAction.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get changePasswordUpdateAction;

  /// No description provided for @changePasswordPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get changePasswordPasswordRequired;

  /// No description provided for @changePasswordConfirmationRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get changePasswordConfirmationRequired;

  /// No description provided for @changePasswordRequirementsMessage.
  ///
  /// In en, this message translates to:
  /// **'Password does not meet the required criteria'**
  String get changePasswordRequirementsMessage;

  /// No description provided for @changePasswordSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Password reset session expired. Please request a new code.'**
  String get changePasswordSessionExpired;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Title shown on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileScreenTitle;

  /// Subtitle shown on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Manage your account information'**
  String get editProfileScreenSubtitle;

  /// Helper text shown below the avatar picker on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'UPLOAD A CLEAR PROFILE PHOTO'**
  String get editProfileUploadPhotoLabel;

  /// Section title shown above the personal information form on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'PERSONAL INFORMATION'**
  String get editProfilePersonalInformation;

  /// Label shown above the full name field on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get editProfileFullNameLabel;

  /// Hint shown inside the full name field on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get editProfileFullNameHint;

  /// Label shown above the username field on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get editProfileUsernameLabel;

  /// Hint shown inside the username field on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get editProfileUsernameHint;

  /// Supporting note shown below the username field on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'This will be visible to other users'**
  String get editProfileUsernameNote;

  /// Label shown above the phone field on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get editProfilePhoneLabel;

  /// Hint shown inside the phone field on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get editProfilePhoneHint;

  /// Label shown above the date of birth field on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get editProfileDateOfBirthLabel;

  /// Hint shown inside the date of birth field on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Select date of birth'**
  String get editProfileDateOfBirthHint;

  /// Label shown above the gender field on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get editProfileGenderLabel;

  /// Hint shown inside the gender field on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get editProfileGenderHint;

  /// Title shown in the gender picker sheet on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get editProfileGenderSheetTitle;

  /// Section title shown above the default address card on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'DEFAULT ADDRESS'**
  String get editProfileDefaultAddressTitle;

  /// Street row label in the default address card on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get editProfileAddressStreet;

  /// State row label in the default address card on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get editProfileAddressState;

  /// Country row label in the default address card on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get editProfileAddressCountry;

  /// Fallback text shown when there is no default address on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'No default address set'**
  String get editProfileNoDefaultAddress;

  /// Fallback label shown when a profile value is missing on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get editProfileFieldNotSet;

  /// Button label shown below the default address card on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Manage Addresses'**
  String get editProfileManageAddresses;

  /// Section title for the interests section on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Style & Interests'**
  String get editProfileInterestsTitle;

  /// Button label to open the profile setup flow for editing interests
  ///
  /// In en, this message translates to:
  /// **'Edit Style & Interests'**
  String get editProfileEditInterestsAction;

  /// Toggle label shown in the security section on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get editProfileTwoFactorTitle;

  /// Toggle label shown in the security section on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get editProfileBiometricTitle;

  /// Title shown on the QR setup sheet for two-factor authentication
  ///
  /// In en, this message translates to:
  /// **'SET UP 2FA'**
  String get twoFactorSetupTitle;

  /// Subtitle shown on the QR setup sheet for two-factor authentication
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code with your authenticator app'**
  String get twoFactorSetupSubtitle;

  /// Label shown above the manual secret key on the two-factor setup sheet
  ///
  /// In en, this message translates to:
  /// **'OR ENTER THIS KEY MANUALLY'**
  String get twoFactorManualKeyLabel;

  /// Primary button label shown on the two-factor setup sheet
  ///
  /// In en, this message translates to:
  /// **'Next Verify Code'**
  String get twoFactorNextVerifyAction;

  /// Title shown on the two-factor verification sheet
  ///
  /// In en, this message translates to:
  /// **'Enter The 6-Digit Code'**
  String get twoFactorVerifyTitle;

  /// Subtitle shown on the two-factor verification sheet
  ///
  /// In en, this message translates to:
  /// **'Open your authenticator app and enter the code shown for SecureApp.'**
  String get twoFactorVerifySubtitle;

  /// Primary action label shown on the two-factor verification sheet
  ///
  /// In en, this message translates to:
  /// **'Verify & Enable'**
  String get twoFactorVerifyAction;

  /// Prefix label shown below the two-factor verification button
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get a code? '**
  String get twoFactorDidNotGetCode;

  /// Action label to reopen the QR setup sheet during two-factor verification
  ///
  /// In en, this message translates to:
  /// **'Rescan QR'**
  String get twoFactorRescanQr;

  /// Action label shown on the change password tile in the security section
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get editProfileResetAction;

  /// Primary save button label on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editProfileSaveAction;

  /// Validation message shown when the full name field is empty on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get editProfileNameRequired;

  /// Validation message shown when the phone number is too short on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get editProfilePhoneInvalid;

  /// Title shown when the edit profile screen fails to load profile data
  ///
  /// In en, this message translates to:
  /// **'Unable to load profile'**
  String get editProfileLoadFailed;

  /// Toast message shown when the profile update succeeds
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get editProfileSavedSuccess;

  /// Toast message shown when the profile update fails
  ///
  /// In en, this message translates to:
  /// **'Unable to update profile'**
  String get editProfileSaveFailed;

  /// Title shown in the photo source sheet on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Choose Photo Source'**
  String get editProfilePhotoSourceTitle;

  /// No description provided for @imagePickerSingleHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo from your gallery or take a new one.'**
  String get imagePickerSingleHint;

  /// No description provided for @imagePickerMultipleHint.
  ///
  /// In en, this message translates to:
  /// **'Choose photos from your gallery or take a new one.'**
  String get imagePickerMultipleHint;

  /// No description provided for @imagePickerGalleryCaptionSingle.
  ///
  /// In en, this message translates to:
  /// **'Pick an existing photo'**
  String get imagePickerGalleryCaptionSingle;

  /// No description provided for @imagePickerGalleryCaptionMultiple.
  ///
  /// In en, this message translates to:
  /// **'Select one or more photos'**
  String get imagePickerGalleryCaptionMultiple;

  /// No description provided for @imagePickerCameraCaption.
  ///
  /// In en, this message translates to:
  /// **'Capture a fresh photo instantly'**
  String get imagePickerCameraCaption;

  /// Camera action label in the photo source sheet on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get editProfilePhotoCameraAction;

  /// Gallery action label in the photo source sheet on the edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get editProfilePhotoGalleryAction;

  /// Title for camera permission disclosure dialog
  ///
  /// In en, this message translates to:
  /// **'Camera Access Required'**
  String get permissionCameraTitle;

  /// Information about data collected for camera
  ///
  /// In en, this message translates to:
  /// **'Data Collected: Images captured via camera'**
  String get permissionCameraDataCollected;

  /// Purpose of camera permission
  ///
  /// In en, this message translates to:
  /// **'Purpose: To capture photos for your profile and styling scans.'**
  String get permissionCameraPurpose;

  /// Usage of camera permission
  ///
  /// In en, this message translates to:
  /// **'Usage: Used to update your avatar and analyze your clothing selections.'**
  String get permissionCameraUsage;

  /// Storage info for camera permission
  ///
  /// In en, this message translates to:
  /// **'Storage & Sharing: Processed securely, stored on our safe servers, and never shared.'**
  String get permissionCameraStorage;

  /// Title for storage/gallery permission disclosure dialog
  ///
  /// In en, this message translates to:
  /// **'Gallery Access Required'**
  String get permissionStorageTitle;

  /// Information about data collected for gallery
  ///
  /// In en, this message translates to:
  /// **'Data Collected: Photos selected from your gallery'**
  String get permissionStorageDataCollected;

  /// Purpose of gallery permission
  ///
  /// In en, this message translates to:
  /// **'Purpose: To upload photos for profile setup and virtual wardrobe.'**
  String get permissionStoragePurpose;

  /// Usage of gallery permission
  ///
  /// In en, this message translates to:
  /// **'Usage: Used to update your avatar and build your virtual outfit collections.'**
  String get permissionStorageUsage;

  /// Storage info for gallery permission
  ///
  /// In en, this message translates to:
  /// **'Storage & Sharing: Processed securely, stored on our safe servers, and never shared.'**
  String get permissionStorageStorage;

  /// Accept button text in permission disclosure dialog
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get permissionAccept;

  /// Deny button text in permission disclosure dialog
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get permissionDeny;

  /// Title for permission permanently denied dialog
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionSettingsTitle;

  /// Explanation for permission permanently denied dialog
  ///
  /// In en, this message translates to:
  /// **'This feature requires camera or gallery access. Please enable the permission in your device Settings.'**
  String get permissionSettingsMessage;

  /// Open settings button text
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get permissionSettingsOpen;

  /// Toast shown when the user taps the change password tile before the feature is implemented
  ///
  /// In en, this message translates to:
  /// **'Change password is not available yet.'**
  String get editProfileChangePasswordUnavailable;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {year}'**
  String memberSince(Object year);

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'SHOPPING'**
  String get shopping;

  /// No description provided for @myOrder.
  ///
  /// In en, this message translates to:
  /// **'My Order'**
  String get myOrder;

  /// No description provided for @trackOrder.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get trackOrder;

  /// No description provided for @savedItems.
  ///
  /// In en, this message translates to:
  /// **'Saved Items'**
  String get savedItems;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @myReviews.
  ///
  /// In en, this message translates to:
  /// **'My Reviews'**
  String get myReviews;

  /// Subtitle shown at the top of the saved items screen
  ///
  /// In en, this message translates to:
  /// **'Your saved drip picks'**
  String get wishlistSubtitle;

  /// Default sort chip label for the saved items screen
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get wishlistTrending;

  /// Error title shown when the saved items request fails
  ///
  /// In en, this message translates to:
  /// **'Unable to load saved items'**
  String get wishlistUnableToLoad;

  /// Title shown when the wishlist is empty
  ///
  /// In en, this message translates to:
  /// **'No saved items yet'**
  String get wishlistEmptyTitle;

  /// Supporting text shown when the wishlist is empty
  ///
  /// In en, this message translates to:
  /// **'Tap Save on any product to keep it here.'**
  String get wishlistEmptySubtitle;

  /// No description provided for @paymentsAndAddress.
  ///
  /// In en, this message translates to:
  /// **'PAYMENTS & ADDRESS'**
  String get paymentsAndAddress;

  /// No description provided for @saveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get saveAddress;

  /// Title shown on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Add Addresses'**
  String get addAddressTitle;

  /// Subtitle shown on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Manage delivery locations'**
  String get addAddressSubtitle;

  /// Section heading shown above the address form
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addAddressSectionTitle;

  /// Label shown above the full name field on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get addAddressFullNameLabel;

  /// Hint shown inside the full name field on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get addAddressFullNameHint;

  /// Label shown above the phone field on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Enter your number'**
  String get addAddressPhoneLabel;

  /// Hint shown inside the phone field on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Enter your number'**
  String get addAddressPhoneHint;

  /// Label shown above the address line field on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Address Line'**
  String get addAddressLineLabel;

  /// Hint shown inside the address line field on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Street address, house number'**
  String get addAddressLineHint;

  /// Label shown above the city field on the add address screen
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get addAddressCityLabel;

  /// Hint shown inside the city field on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Enter your city'**
  String get addAddressCityHint;

  /// Label shown above the postal field on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Postal'**
  String get addAddressPostalLabel;

  /// Hint shown inside the postal field on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Enter postal code'**
  String get addAddressPostalHint;

  /// Label shown above the state or province field on the add address screen
  ///
  /// In en, this message translates to:
  /// **'State / Province'**
  String get addAddressStateLabel;

  /// Hint shown inside the state or province field on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Enter state or province'**
  String get addAddressStateHint;

  /// Title shown above the address label selector on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Address Label'**
  String get addAddressLabelTitle;

  /// Home label option on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get addAddressLabelHome;

  /// Work label option on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get addAddressLabelWork;

  /// Other label option on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get addAddressLabelOther;

  /// Label shown beside the default address switch on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Set As Default Address'**
  String get addAddressDefaultTitle;

  /// Informational text shown below the default address switch on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Your address information is securely stored and used only for order deliveries.'**
  String get addAddressInfoNote;

  /// Primary button label on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get addAddressSaveButton;

  /// Title shown on the edit address screen
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddressTitle;

  /// Section heading shown above the edit address form
  ///
  /// In en, this message translates to:
  /// **'Update Address'**
  String get editAddressSectionTitle;

  /// Primary button label on the edit address screen
  ///
  /// In en, this message translates to:
  /// **'Update Address'**
  String get updateAddressSaveButton;

  /// Validation message shown when full name is missing on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get addAddressRequiredName;

  /// Validation message shown when phone number is missing on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get addAddressRequiredPhone;

  /// Validation message shown when the address line is missing on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Please enter your street address'**
  String get addAddressRequiredAddressLine;

  /// Validation message shown when city is missing on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Please enter your city'**
  String get addAddressRequiredCity;

  /// Validation message shown when postal code is missing on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Please enter your postal code'**
  String get addAddressRequiredPostal;

  /// Validation message shown when state or province is missing on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Please enter your state or province'**
  String get addAddressRequiredState;

  /// Validation message shown when the phone number is too short on the add address screen
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get addAddressInvalidPhone;

  /// Toast message shown when the address form has validation errors
  ///
  /// In en, this message translates to:
  /// **'Please complete the required fields'**
  String get addAddressValidationError;

  /// Toast message shown when the address is saved successfully
  ///
  /// In en, this message translates to:
  /// **'Address saved successfully'**
  String get addAddressSavedSuccess;

  /// Toast message shown when saving the address fails
  ///
  /// In en, this message translates to:
  /// **'Unable to save address'**
  String get addAddressSaveFailed;

  /// Toast message shown when the address is updated successfully
  ///
  /// In en, this message translates to:
  /// **'Address updated successfully'**
  String get updateAddressSavedSuccess;

  /// Toast message shown when updating the address fails
  ///
  /// In en, this message translates to:
  /// **'Unable to update address'**
  String get updateAddressSaveFailed;

  /// Title shown on the my addresses listing screen
  ///
  /// In en, this message translates to:
  /// **'My Addresses'**
  String get myAddressesTitle;

  /// Primary action button label on the my addresses screen
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get myAddressesAddNewButton;

  /// Badge label shown for the default saved address
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get myAddressesDefaultBadge;

  /// Edit action label shown on a saved address card
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get myAddressesEditAction;

  /// Delete action label shown on a saved address card
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get myAddressesDeleteAction;

  /// Delete action label shown on a saved address card while deletion is in progress
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get myAddressesDeletingAction;

  /// Title shown when the user has no saved addresses
  ///
  /// In en, this message translates to:
  /// **'No saved addresses yet'**
  String get myAddressesEmptyTitle;

  /// Supporting text shown when the user has no saved addresses
  ///
  /// In en, this message translates to:
  /// **'Add a delivery address to make checkout faster.'**
  String get myAddressesEmptySubtitle;

  /// Title shown when the addresses screen fails to load
  ///
  /// In en, this message translates to:
  /// **'Unable to load addresses'**
  String get myAddressesLoadFailed;

  /// Toast shown when the user taps edit on a saved address card before editing is implemented
  ///
  /// In en, this message translates to:
  /// **'Address editing is not available yet.'**
  String get myAddressesEditUnavailable;

  /// Toast shown when the user taps delete on a saved address card before deletion is implemented
  ///
  /// In en, this message translates to:
  /// **'Address deletion is not available yet.'**
  String get myAddressesDeleteUnavailable;

  /// Title shown in the delete address confirmation sheet
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get deleteAddressSheetTitle;

  /// Subtitle shown in the delete address confirmation sheet
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this saved address?'**
  String get deleteAddressSheetSubtitle;

  /// Warning text shown in the delete address confirmation sheet
  ///
  /// In en, this message translates to:
  /// **'This address will be removed from your delivery locations.'**
  String get deleteAddressSheetWarning;

  /// Primary destructive action label in the delete address confirmation sheet
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get deleteAddressConfirmAction;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// Subtitle shown below the payment methods page title
  ///
  /// In en, this message translates to:
  /// **'Encrypted & Secure'**
  String get paymentMethodsEncryptedSecure;

  /// Section heading shown above the digital wallet payment options
  ///
  /// In en, this message translates to:
  /// **'Digital Wallets'**
  String get paymentMethodsDigitalWalletsHeading;

  /// Section heading shown above the supported payment methods list
  ///
  /// In en, this message translates to:
  /// **'Supported Payment Methods'**
  String get paymentMethodsSupportedSectionTitle;

  /// Badge shown on the recommended payment method card
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get paymentMethodsRecommendedBadge;

  /// Badge shown on the Apple Pay payment method card
  ///
  /// In en, this message translates to:
  /// **'iOS & Mac'**
  String get paymentMethodsIosAndMacBadge;

  /// Description shown on the Google Pay payment method card
  ///
  /// In en, this message translates to:
  /// **'Fast, secure checkout using your Google Account. Supports cards, bank accounts & rewards.'**
  String get paymentMethodsGooglePayDescription;

  /// Description shown on the Apple Pay payment method card
  ///
  /// In en, this message translates to:
  /// **'Pay instantly with Face ID or Touch ID. Works with Apple Card, debit & credit cards in Wallet.'**
  String get paymentMethodsApplePayDescription;

  /// Primary action label shown on the Google Pay payment method card
  ///
  /// In en, this message translates to:
  /// **'Pay With Google Pay'**
  String get paymentMethodsGooglePayAction;

  /// Primary action label shown on the Apple Pay payment method card
  ///
  /// In en, this message translates to:
  /// **'Pay With Apple Pay'**
  String get paymentMethodsApplePayAction;

  /// Label shown for the credit and debit card supported payment type
  ///
  /// In en, this message translates to:
  /// **'Credit/Debit'**
  String get paymentMethodsCreditDebit;

  /// Message shown when the payment methods screen fails to load
  ///
  /// In en, this message translates to:
  /// **'Unable to load payment methods.'**
  String get paymentMethodsLoadFailed;

  /// Message shown when the payment methods screen has no methods to display
  ///
  /// In en, this message translates to:
  /// **'No payment methods are available right now.'**
  String get paymentMethodsEmptyState;

  /// Message shown when there are no supported payment methods to display
  ///
  /// In en, this message translates to:
  /// **'Supported payment methods will appear here.'**
  String get paymentMethodsNoSupportedOptions;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Title shown in the delete account confirmation sheet
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountSheetTitle;

  /// Subtitle shown in the delete account confirmation sheet
  ///
  /// In en, this message translates to:
  /// **'We\'ll miss you. This decision can\'t be undone.'**
  String get deleteAccountSheetSubtitle;

  /// Warning text shown in the delete account sheet
  ///
  /// In en, this message translates to:
  /// **'All your data, order history, saved items, and preferences will be permanently removed from DripTalk.'**
  String get deleteAccountWarningMessage;

  /// Label shown above the delete account email field
  ///
  /// In en, this message translates to:
  /// **'Enter your email:'**
  String get deleteAccountEmailLabel;

  /// Hint shown inside the delete account email field
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get deleteAccountEmailHint;

  /// Label shown above the delete account password field
  ///
  /// In en, this message translates to:
  /// **'Enter your password:'**
  String get deleteAccountPasswordLabel;

  /// Hint shown inside the delete account password field
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get deleteAccountPasswordHint;

  /// Acknowledgement text shown in the delete account sheet
  ///
  /// In en, this message translates to:
  /// **'I understand that this action is permanent and all my data will be deleted.'**
  String get deleteAccountAcknowledgement;

  /// Validation message shown when the delete account acknowledgement is not checked
  ///
  /// In en, this message translates to:
  /// **'Please confirm that you understand this permanent action.'**
  String get deleteAccountAcknowledgementRequired;

  /// Primary destructive action label in the delete account sheet
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAccountConfirmAction;

  /// Validation message for the delete account email field
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get deleteAccountEmailRequired;

  /// Validation message for the delete account password field
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get deleteAccountPasswordRequired;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get support;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @contactSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Our team is here to help you 24/7.'**
  String get contactSupportSubtitle;

  /// No description provided for @contactSupportQuickContactOptions.
  ///
  /// In en, this message translates to:
  /// **'Quick Contact Options'**
  String get contactSupportQuickContactOptions;

  /// No description provided for @contactSupportEmailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get contactSupportEmailSupport;

  /// No description provided for @contactSupportEmailResponseTime.
  ///
  /// In en, this message translates to:
  /// **'Response Within 24 Hours'**
  String get contactSupportEmailResponseTime;

  /// No description provided for @contactSupportPhoneSupport.
  ///
  /// In en, this message translates to:
  /// **'Phone Support'**
  String get contactSupportPhoneSupport;

  /// No description provided for @contactSupportPhoneAvailability.
  ///
  /// In en, this message translates to:
  /// **'Available 9AM–6PM (Mon–Fri)'**
  String get contactSupportPhoneAvailability;

  /// No description provided for @contactSupportSubmitARequest.
  ///
  /// In en, this message translates to:
  /// **'Submit A Request'**
  String get contactSupportSubmitARequest;

  /// No description provided for @contactSupportNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get contactSupportNameLabel;

  /// No description provided for @contactSupportNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get contactSupportNameHint;

  /// No description provided for @contactSupportEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get contactSupportEmailLabel;

  /// No description provided for @contactSupportEmailHint.
  ///
  /// In en, this message translates to:
  /// **'dianne@email.com'**
  String get contactSupportEmailHint;

  /// No description provided for @contactSupportOrderIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get contactSupportOrderIdLabel;

  /// No description provided for @contactSupportOrderIdHint.
  ///
  /// In en, this message translates to:
  /// **'#DT20231215'**
  String get contactSupportOrderIdHint;

  /// No description provided for @contactSupportIssueTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Issue Type'**
  String get contactSupportIssueTypeLabel;

  /// No description provided for @contactSupportMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get contactSupportMessageLabel;

  /// No description provided for @contactSupportMessageHint.
  ///
  /// In en, this message translates to:
  /// **'My order hasn’t arrived yet and it’s been 5 days. Can you help me track it?'**
  String get contactSupportMessageHint;

  /// No description provided for @contactSupportSubmitAction.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get contactSupportSubmitAction;

  /// No description provided for @contactSupportSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your support request has been submitted successfully.'**
  String get contactSupportSubmitSuccess;

  /// No description provided for @contactSupportSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to submit your support request.'**
  String get contactSupportSubmitFailed;

  /// No description provided for @contactSupportNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required.'**
  String get contactSupportNameRequired;

  /// No description provided for @contactSupportNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters.'**
  String get contactSupportNameTooShort;

  /// No description provided for @contactSupportEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required.'**
  String get contactSupportEmailRequired;

  /// No description provided for @contactSupportEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get contactSupportEmailInvalid;

  /// No description provided for @contactSupportMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Message is required.'**
  String get contactSupportMessageRequired;

  /// No description provided for @contactSupportEmailLaunchFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to open the email app. Contact us at usamaali1458@gmail.com.'**
  String get contactSupportEmailLaunchFailed;

  /// No description provided for @contactSupportPhoneLaunchFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to open the phone app. Call us at 03186202230.'**
  String get contactSupportPhoneLaunchFailed;

  /// No description provided for @contactSupportIssueTypeOrderIssue.
  ///
  /// In en, this message translates to:
  /// **'Order Issue'**
  String get contactSupportIssueTypeOrderIssue;

  /// No description provided for @contactSupportIssueTypePaymentIssue.
  ///
  /// In en, this message translates to:
  /// **'Payment Issue'**
  String get contactSupportIssueTypePaymentIssue;

  /// No description provided for @contactSupportIssueTypeShippingDelay.
  ///
  /// In en, this message translates to:
  /// **'Shipping Delay'**
  String get contactSupportIssueTypeShippingDelay;

  /// No description provided for @contactSupportIssueTypeReturnRefund.
  ///
  /// In en, this message translates to:
  /// **'Return & Refund'**
  String get contactSupportIssueTypeReturnRefund;

  /// No description provided for @contactSupportIssueTypeAccountIssue.
  ///
  /// In en, this message translates to:
  /// **'Account Issue'**
  String get contactSupportIssueTypeAccountIssue;

  /// No description provided for @contactSupportIssueTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get contactSupportIssueTypeOther;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQ\'s'**
  String get faqs;

  /// No description provided for @returnPolicy.
  ///
  /// In en, this message translates to:
  /// **'Return Policy'**
  String get returnPolicy;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// Shop section title for curated collections
  ///
  /// In en, this message translates to:
  /// **'AI Curated Collections'**
  String get shopAiCuratedCollections;

  /// Shop action label for viewing all collections
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get shopSeeAll;

  /// Title for the streetwear curated collection
  ///
  /// In en, this message translates to:
  /// **'Streetwear Essentials'**
  String get shopCollectionStreetwearEssentials;

  /// Title for the casual curated collection
  ///
  /// In en, this message translates to:
  /// **'Casual Everyday'**
  String get shopCollectionCasualEveryday;

  /// Title for the party curated collection
  ///
  /// In en, this message translates to:
  /// **'Party Night Drip'**
  String get shopCollectionPartyNightDrip;

  /// Label for the number of items in a curated collection
  ///
  /// In en, this message translates to:
  /// **'{count} Items'**
  String shopCollectionItems(int count);

  /// Promotional text on the AI shopping banner
  ///
  /// In en, this message translates to:
  /// **'AI found these outfits for your style profile'**
  String get shopAiStyleProfileText;

  /// CTA label on the AI shopping banner
  ///
  /// In en, this message translates to:
  /// **'Ask AI for Shopping Advice'**
  String get shopAskAiShoppingAdvice;

  /// Error message shown when shop products fail to load
  ///
  /// In en, this message translates to:
  /// **'Unable to load products'**
  String get shopUnableToLoadProducts;

  /// Error message shown when AI curated collections fail to load
  ///
  /// In en, this message translates to:
  /// **'Unable to load collections'**
  String get shopUnableToLoadCollections;

  /// Hint text for searching curated collections on the see all screen
  ///
  /// In en, this message translates to:
  /// **'Search curated collections'**
  String get shopSearchCollectionsHint;

  /// Hint text for searching products inside a curated collection
  ///
  /// In en, this message translates to:
  /// **'Search fashion...'**
  String get shopSearchCollectionProductsHint;

  /// Message shown when the current shop filter returns no products
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get shopNoProductsFound;

  /// Message shown when a curated collection has no products
  ///
  /// In en, this message translates to:
  /// **'No products available in this collection'**
  String get shopNoProductsInCollection;

  /// Message shown when the AI curated collections API returns no items
  ///
  /// In en, this message translates to:
  /// **'No curated collections available'**
  String get shopNoCuratedCollections;

  /// Message shown in the shop curated section when there are no featured collections
  ///
  /// In en, this message translates to:
  /// **'No featured collections available'**
  String get shopNoFeaturedCollections;

  /// Message shown when curated collection search returns no visible results
  ///
  /// In en, this message translates to:
  /// **'No collections match your search'**
  String get shopNoCollectionResults;

  /// Error message shown when a curated collection details request fails
  ///
  /// In en, this message translates to:
  /// **'Unable to load collection details'**
  String get shopUnableToLoadCollectionDetails;

  /// Header title shown on the curated collection details screen
  ///
  /// In en, this message translates to:
  /// **'DripTalk Picks'**
  String get shopDripTalkPicksTitle;

  /// Label for the add to cart button in product cards
  ///
  /// In en, this message translates to:
  /// **'Add To Cart'**
  String get shopAddToCart;

  /// Label for the save button in product cards
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get shopSave;

  /// Label for the all categories filter option in the shop
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get shopCategoryAll;

  /// Title shown in the shop filters bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get shopFilterTitle;

  /// Heading for the price range section in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get shopFilterPriceRange;

  /// Hint for the minimum price field in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Min \$'**
  String get shopFilterMinPriceHint;

  /// Hint for the maximum price field in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Max \$'**
  String get shopFilterMaxPriceHint;

  /// Connector text between min and max price in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get shopFilterTo;

  /// Heading for the categories filter section in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get shopFilterCategories;

  /// Heading for the size filter section in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Sizes'**
  String get shopFilterSizes;

  /// Heading for the brand filter section in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get shopFilterBrands;

  /// Heading for the sort filter section in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get shopFilterSortBy;

  /// Heading for the gender filter section in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get shopFilterGender;

  /// Primary action button label in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get shopFilterApply;

  /// Secondary reset button label in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get shopFilterReset;

  /// Fallback label shown when a filter section has no options
  ///
  /// In en, this message translates to:
  /// **'No options available'**
  String get shopFilterNoOptions;

  /// Default sort option label in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get shopFilterSortDefault;

  /// Sort option label for ascending price in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Price low to high'**
  String get shopFilterSortPriceLowToHigh;

  /// Sort option label for descending price in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Price high to low'**
  String get shopFilterSortPriceHighToLow;

  /// Sort option label for name ascending in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Name A to Z'**
  String get shopFilterSortNameAToZ;

  /// Sort option label for name descending in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Name Z to A'**
  String get shopFilterSortNameZToA;

  /// Male gender option label in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get shopFilterGenderMale;

  /// Female gender option label in the shop filter sheet
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get shopFilterGenderFemale;

  /// Title shown in the product details app bar
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetailsTitle;

  /// Heading for the product color selector
  ///
  /// In en, this message translates to:
  /// **'Choose Color'**
  String get productChooseColor;

  /// Heading for the product size selector
  ///
  /// In en, this message translates to:
  /// **'Select Size'**
  String get productSelectSize;

  /// Action label for opening the product size guide
  ///
  /// In en, this message translates to:
  /// **'Size Guide'**
  String get productSizeGuide;

  /// Subtitle shown below the size guide title in the sheet
  ///
  /// In en, this message translates to:
  /// **'Find your perfect fit'**
  String get productSizeGuideSubtitle;

  /// Badge title shown on the AI fit card in the size guide sheet
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Fit'**
  String get productSizeGuideAiBadge;

  /// Hero title shown in the size guide sheet
  ///
  /// In en, this message translates to:
  /// **'Find your perfect size in seconds'**
  String get productSizeGuideHeroTitle;

  /// Supporting text shown in the size guide sheet hero card
  ///
  /// In en, this message translates to:
  /// **'Based on 50,000+ measurements, we recommend the ideal fit for your style.'**
  String get productSizeGuideHeroDescription;

  /// Label for the chest measurement in the product size guide
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get productSizeGuideChest;

  /// Label for the waist measurement in the product size guide
  ///
  /// In en, this message translates to:
  /// **'Waist'**
  String get productSizeGuideWaist;

  /// Label for the length measurement in the product size guide
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get productSizeGuideLength;

  /// Title for the body measurements block in the size guide sheet
  ///
  /// In en, this message translates to:
  /// **'BODY MEASUREMENTS'**
  String get productBodyMeasurements;

  /// Footnote shown under the body measurements title in the size guide sheet
  ///
  /// In en, this message translates to:
  /// **'In inches • for reference only'**
  String get productMeasurementsReference;

  /// Save button label in the size guide sheet
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get productSaveSizeSelection;

  /// Review count shown in the product rating row
  ///
  /// In en, this message translates to:
  /// **'({count} Reviews)'**
  String productReviewsCount(int count);

  /// Label for the buy now action on the product screen
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get productBuyNow;

  /// Status label shown when a product is out of stock
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get productOutOfStock;

  /// Status label shown when a product is in stock
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get productInStock;

  /// Heading for the recommended section on the product screen
  ///
  /// In en, this message translates to:
  /// **'You Might Also Like'**
  String get productYouMightAlsoLike;

  /// Error message shown when product details fail to load
  ///
  /// In en, this message translates to:
  /// **'Unable to load product details'**
  String get productUnableToLoad;

  /// Discount label shown on the product details card
  ///
  /// In en, this message translates to:
  /// **'{percentage}% OFF'**
  String productDiscountPercentage(int percentage);

  /// Title shown on the cart screen
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get cartTitle;

  /// Label for the number of items shown in the cart header
  ///
  /// In en, this message translates to:
  /// **'{count} Items'**
  String cartItemsCount(int count);

  /// Label for selected size in a cart item
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get cartSize;

  /// Label for selected color in a cart item
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get cartColor;

  /// Heading for the order summary card on the cart screen
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get cartOrderSummary;

  /// Label for cart subtotal
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get cartSubtotal;

  /// Label for cart shipping amount
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get cartShipping;

  /// Label for cart discount amount
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get cartDiscount;

  /// Label for cart tax amount
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get cartTax;

  /// Label for the final total amount in the cart
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get cartTotal;

  /// Hint text for the promo code field in the cart summary
  ///
  /// In en, this message translates to:
  /// **'Enter promo code'**
  String get cartPromoCodeHint;

  /// Button label for applying a promo code in the cart
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get cartApply;

  /// Checkout button label showing the cart total
  ///
  /// In en, this message translates to:
  /// **'Checkout • {total}'**
  String cartCheckoutTotal(String total);

  /// Title shown when the cart has no items
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmptyTitle;

  /// Supporting text shown when the cart is empty
  ///
  /// In en, this message translates to:
  /// **'Add products from the shop to see them here.'**
  String get cartEmptySubtitle;

  /// Action button label for navigating back to the shop from an empty cart state
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get cartContinueShopping;

  /// Error title shown when the cart request fails
  ///
  /// In en, this message translates to:
  /// **'Unable to load cart'**
  String get cartUnableToLoad;

  /// Informational message shown when promo code functionality is unavailable
  ///
  /// In en, this message translates to:
  /// **'Promo codes are not available yet'**
  String get cartPromoUnavailable;

  /// Error message shown when add-to-cart is attempted without a valid product variant
  ///
  /// In en, this message translates to:
  /// **'This product variant is unavailable'**
  String get cartVariantUnavailable;

  /// No description provided for @chatAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'DripTalk AI'**
  String get chatAppBarTitle;

  /// No description provided for @chatTypeMessageFirst.
  ///
  /// In en, this message translates to:
  /// **'Type a message first!'**
  String get chatTypeMessageFirst;

  /// No description provided for @chatTypeMessageOrAttachImageFirst.
  ///
  /// In en, this message translates to:
  /// **'Type a message or attach at least one image first!'**
  String get chatTypeMessageOrAttachImageFirst;

  /// No description provided for @chatAttachImages.
  ///
  /// In en, this message translates to:
  /// **'Attach images'**
  String get chatAttachImages;

  /// No description provided for @chatSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get chatSendMessage;

  /// No description provided for @chatSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search fashion...'**
  String get chatSearchHint;

  /// No description provided for @chatLoadingPreviousChat.
  ///
  /// In en, this message translates to:
  /// **'Loading your previous chat...'**
  String get chatLoadingPreviousChat;

  /// No description provided for @chatSessionChoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Chat'**
  String get chatSessionChoiceTitle;

  /// No description provided for @chatSessionStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Start Your Chat'**
  String get chatSessionStartTitle;

  /// No description provided for @chatSessionChoiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Continue your last styling conversation or begin a fresh session.'**
  String get chatSessionChoiceDescription;

  /// No description provided for @chatSessionStartDescription.
  ///
  /// In en, this message translates to:
  /// **'No saved session was found. Start a new styling conversation.'**
  String get chatSessionStartDescription;

  /// No description provided for @chatContinueOldChat.
  ///
  /// In en, this message translates to:
  /// **'Continue Old Chat'**
  String get chatContinueOldChat;

  /// No description provided for @chatStartNewChat.
  ///
  /// In en, this message translates to:
  /// **'Start New Chat'**
  String get chatStartNewChat;

  /// No description provided for @chatIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m Your AI Stylist'**
  String get chatIntroTitle;

  /// No description provided for @chatIntroMessage.
  ///
  /// In en, this message translates to:
  /// **'I can help you with outfit recommendations, styling tips, fashion advice, and more. Try asking me anything about fashion!'**
  String get chatIntroMessage;

  /// No description provided for @chatAiPicks.
  ///
  /// In en, this message translates to:
  /// **'AI Picks'**
  String get chatAiPicks;

  /// No description provided for @chatCatalogMatches.
  ///
  /// In en, this message translates to:
  /// **'Catalog Matches'**
  String get chatCatalogMatches;

  /// No description provided for @chatAiRecommendationFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'AI recommendation'**
  String get chatAiRecommendationFallbackTitle;

  /// No description provided for @chatAiRecommendationFallbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'External product recommendation'**
  String get chatAiRecommendationFallbackSubtitle;

  /// No description provided for @chatBrowserAction.
  ///
  /// In en, this message translates to:
  /// **'Browser'**
  String get chatBrowserAction;

  /// No description provided for @chatShopAction.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get chatShopAction;

  /// No description provided for @chatAiPick.
  ///
  /// In en, this message translates to:
  /// **'AI Pick'**
  String get chatAiPick;

  /// No description provided for @chatProductLinkUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This product link is unavailable.'**
  String get chatProductLinkUnavailable;

  /// No description provided for @chatProductOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open this product right now.'**
  String get chatProductOpenFailed;

  /// No description provided for @chatFreeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Free delivery'**
  String get chatFreeDelivery;

  /// No description provided for @chatFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get chatFeatured;

  /// No description provided for @chatCatalogProductFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Catalog product'**
  String get chatCatalogProductFallbackTitle;

  /// No description provided for @chatCatalogProductFallbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shop this from the catalog'**
  String get chatCatalogProductFallbackSubtitle;

  /// No description provided for @chatCatalogAction.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get chatCatalogAction;

  /// No description provided for @chatCatalogProductUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This catalog product is unavailable right now.'**
  String get chatCatalogProductUnavailable;

  /// No description provided for @chatHistoryFallbackMessage.
  ///
  /// In en, this message translates to:
  /// **'Here is your previous recommendation.'**
  String get chatHistoryFallbackMessage;

  /// No description provided for @chatAssistantSummaryAiAndCatalog.
  ///
  /// In en, this message translates to:
  /// **'I found {aiCount} AI picks and {catalogCount} catalog matches for this look.'**
  String chatAssistantSummaryAiAndCatalog(Object aiCount, Object catalogCount);

  /// No description provided for @chatAssistantSummaryAiOnly.
  ///
  /// In en, this message translates to:
  /// **'I found {aiCount} AI-picked products you can shop right away.'**
  String chatAssistantSummaryAiOnly(Object aiCount);

  /// No description provided for @chatAssistantSummaryCatalogOnly.
  ///
  /// In en, this message translates to:
  /// **'I found {catalogCount} catalog matches from the app for this request.'**
  String chatAssistantSummaryCatalogOnly(Object catalogCount);

  /// No description provided for @chatAssistantSummaryGeneric.
  ///
  /// In en, this message translates to:
  /// **'I analyzed your request and pulled together a few recommendations.'**
  String get chatAssistantSummaryGeneric;

  /// No description provided for @chatGenericErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'I could not load recommendations right now. Please try again.'**
  String get chatGenericErrorMessage;

  /// No description provided for @chatPreferencesGenderQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your gender?'**
  String get chatPreferencesGenderQuestion;

  /// No description provided for @chatPreferencesOccasionQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s the occasion?'**
  String get chatPreferencesOccasionQuestion;

  /// No description provided for @chatPreferencesSeasonQuestion.
  ///
  /// In en, this message translates to:
  /// **'Current season?'**
  String get chatPreferencesSeasonQuestion;

  /// No description provided for @chatPreferencesBudgetQuestion.
  ///
  /// In en, this message translates to:
  /// **'Your budget range?'**
  String get chatPreferencesBudgetQuestion;

  /// No description provided for @chatPreferencesStepCounter.
  ///
  /// In en, this message translates to:
  /// **'STEP {current} OF {total}'**
  String chatPreferencesStepCounter(Object current, Object total);

  /// No description provided for @chatPreferencesBudgetMin.
  ///
  /// In en, this message translates to:
  /// **'Min: \${amount}'**
  String chatPreferencesBudgetMin(Object amount);

  /// No description provided for @chatPreferencesBudgetValue.
  ///
  /// In en, this message translates to:
  /// **'\${amount}'**
  String chatPreferencesBudgetValue(Object amount);

  /// No description provided for @chatPreferencesBudgetMax.
  ///
  /// In en, this message translates to:
  /// **'Max: \${amount}'**
  String chatPreferencesBudgetMax(Object amount);

  /// No description provided for @chatFindMyStyle.
  ///
  /// In en, this message translates to:
  /// **'Find my style'**
  String get chatFindMyStyle;

  /// No description provided for @chatGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get chatGenderMale;

  /// No description provided for @chatGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get chatGenderFemale;

  /// No description provided for @chatGenderNonBinary.
  ///
  /// In en, this message translates to:
  /// **'Non-binary'**
  String get chatGenderNonBinary;

  /// No description provided for @chatGenderPreferNotSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get chatGenderPreferNotSay;

  /// No description provided for @chatOccasionOffice.
  ///
  /// In en, this message translates to:
  /// **'Office / Work'**
  String get chatOccasionOffice;

  /// No description provided for @chatOccasionParty.
  ///
  /// In en, this message translates to:
  /// **'Party / Night Out'**
  String get chatOccasionParty;

  /// No description provided for @chatOccasionCasual.
  ///
  /// In en, this message translates to:
  /// **'Casual Day'**
  String get chatOccasionCasual;

  /// No description provided for @chatOccasionSports.
  ///
  /// In en, this message translates to:
  /// **'Sports / Active'**
  String get chatOccasionSports;

  /// No description provided for @chatOccasionWedding.
  ///
  /// In en, this message translates to:
  /// **'Wedding / Formal'**
  String get chatOccasionWedding;

  /// No description provided for @chatOccasionDateNight.
  ///
  /// In en, this message translates to:
  /// **'Date Night'**
  String get chatOccasionDateNight;

  /// No description provided for @chatSeasonSpring.
  ///
  /// In en, this message translates to:
  /// **'Spring'**
  String get chatSeasonSpring;

  /// No description provided for @chatSeasonSummer.
  ///
  /// In en, this message translates to:
  /// **'Summer'**
  String get chatSeasonSummer;

  /// No description provided for @chatSeasonAutumn.
  ///
  /// In en, this message translates to:
  /// **'Autumn'**
  String get chatSeasonAutumn;

  /// No description provided for @chatSeasonWinter.
  ///
  /// In en, this message translates to:
  /// **'Winter'**
  String get chatSeasonWinter;

  /// No description provided for @requestCanceled.
  ///
  /// In en, this message translates to:
  /// **'Request canceled'**
  String get requestCanceled;

  /// No description provided for @sessionExpiredLoginAgain.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get sessionExpiredLoginAgain;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @wardrobeUntitledTitle.
  ///
  /// In en, this message translates to:
  /// **'Untitled Wardrobe'**
  String get wardrobeUntitledTitle;

  /// No description provided for @wardrobeListHeaderLeading.
  ///
  /// In en, this message translates to:
  /// **'MY'**
  String get wardrobeListHeaderLeading;

  /// No description provided for @wardrobeListHeaderAccent.
  ///
  /// In en, this message translates to:
  /// **'Wardrobes'**
  String get wardrobeListHeaderAccent;

  /// No description provided for @wardrobeListHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your Fits, All In One Place'**
  String get wardrobeListHeaderSubtitle;

  /// No description provided for @wardrobeListLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to load wardrobes right now.'**
  String get wardrobeListLoadFailed;

  /// No description provided for @wardrobeListCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create Wardrobe'**
  String get wardrobeListCreateAction;

  /// No description provided for @wardrobeListDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete wardrobe?'**
  String get wardrobeListDeleteDialogTitle;

  /// No description provided for @wardrobeListDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete \"{wardrobeName}\" and every dress inside it.'**
  String wardrobeListDeleteDialogMessage(Object wardrobeName);

  /// No description provided for @wardrobeInWardrobeLabel.
  ///
  /// In en, this message translates to:
  /// **'In Wardrobe'**
  String get wardrobeInWardrobeLabel;

  /// No description provided for @wardrobeInLaundryLabel.
  ///
  /// In en, this message translates to:
  /// **'In Laundry'**
  String get wardrobeInLaundryLabel;

  /// No description provided for @wardrobeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Wardrobes Yet'**
  String get wardrobeEmptyTitle;

  /// No description provided for @wardrobeEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first wardrobe to start organizing your style.'**
  String get wardrobeEmptySubtitle;

  /// No description provided for @wardrobeEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Create your first wardrobe'**
  String get wardrobeEmptyAction;

  /// No description provided for @wardrobeCreateHeaderLeading.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get wardrobeCreateHeaderLeading;

  /// No description provided for @wardrobeCreateHeaderAccent.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe'**
  String get wardrobeCreateHeaderAccent;

  /// No description provided for @wardrobeCreateHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build Your Next Fit Collection'**
  String get wardrobeCreateHeaderSubtitle;

  /// No description provided for @wardrobeNameHint.
  ///
  /// In en, this message translates to:
  /// **'Eg. Summer Collection'**
  String get wardrobeNameHint;

  /// No description provided for @wardrobeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe Name'**
  String get wardrobeNameLabel;

  /// No description provided for @wardrobeCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Add to Wardrobe'**
  String get wardrobeCreateAction;

  /// No description provided for @wardrobeUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Tap To Add All Your Dresses'**
  String get wardrobeUploadTitle;

  /// No description provided for @wardrobeUploadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select as many as you want at once - all at one go'**
  String get wardrobeUploadSubtitle;

  /// No description provided for @wardrobeUploadAction.
  ///
  /// In en, this message translates to:
  /// **'Choose Dress'**
  String get wardrobeUploadAction;

  /// No description provided for @wardrobeNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe name is required'**
  String get wardrobeNameRequired;

  /// No description provided for @wardrobeImageRequired.
  ///
  /// In en, this message translates to:
  /// **'Add at least one dress image'**
  String get wardrobeImageRequired;

  /// No description provided for @wardrobeCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe created successfully'**
  String get wardrobeCreatedSuccess;

  /// No description provided for @wardrobeCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to create wardrobe'**
  String get wardrobeCreateFailed;

  /// No description provided for @wardrobeDetailsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to load wardrobe'**
  String get wardrobeDetailsLoadFailed;

  /// No description provided for @wardrobeDetailsTotalDressesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} Total Dresses'**
  String wardrobeDetailsTotalDressesSubtitle(Object count);

  /// No description provided for @wardrobeMoveSelectedItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Move Selected Item'**
  String get wardrobeMoveSelectedItemTitle;

  /// No description provided for @wardrobeSendToAction.
  ///
  /// In en, this message translates to:
  /// **'Send To...'**
  String get wardrobeSendToAction;

  /// No description provided for @wardrobeSendToLaundryDialogAction.
  ///
  /// In en, this message translates to:
  /// **'Send to laundry'**
  String get wardrobeSendToLaundryDialogAction;

  /// No description provided for @wardrobeSendToWardrobeDialogAction.
  ///
  /// In en, this message translates to:
  /// **'Send to wardrobe'**
  String get wardrobeSendToWardrobeDialogAction;

  /// No description provided for @wardrobeSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get wardrobeSaveAction;

  /// No description provided for @wardrobeSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get wardrobeSelectHint;

  /// No description provided for @wardrobeClearAllAction.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get wardrobeClearAllAction;

  /// No description provided for @wardrobeSelectAllAction.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get wardrobeSelectAllAction;

  /// No description provided for @wardrobeRemoveFromLaundryAction.
  ///
  /// In en, this message translates to:
  /// **'Remove From Laundry'**
  String get wardrobeRemoveFromLaundryAction;

  /// No description provided for @wardrobeSendToLaundryAction.
  ///
  /// In en, this message translates to:
  /// **'Send To Laundry'**
  String get wardrobeSendToLaundryAction;

  /// No description provided for @wardrobeWardrobeLabel.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe'**
  String get wardrobeWardrobeLabel;

  /// No description provided for @wardrobeLaundryLabel.
  ///
  /// In en, this message translates to:
  /// **'Laundry'**
  String get wardrobeLaundryLabel;

  /// No description provided for @wardrobeTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get wardrobeTotalLabel;

  /// No description provided for @wardrobeAllLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get wardrobeAllLabel;

  /// No description provided for @wardrobeProcessingLabel.
  ///
  /// In en, this message translates to:
  /// **'AI processing'**
  String get wardrobeProcessingLabel;

  /// No description provided for @wardrobeNoDressesInWardrobe.
  ///
  /// In en, this message translates to:
  /// **'No dresses in this wardrobe yet.'**
  String get wardrobeNoDressesInWardrobe;

  /// No description provided for @wardrobeNoDressesInWardrobeFilter.
  ///
  /// In en, this message translates to:
  /// **'No dresses currently in wardrobe.'**
  String get wardrobeNoDressesInWardrobeFilter;

  /// No description provided for @wardrobeNoDressesInLaundryFilter.
  ///
  /// In en, this message translates to:
  /// **'No dresses currently in laundry.'**
  String get wardrobeNoDressesInLaundryFilter;

  /// No description provided for @wardrobeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe not found'**
  String get wardrobeNotFound;

  /// No description provided for @wardrobeDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe deleted successfully'**
  String get wardrobeDeleteSuccess;

  /// No description provided for @wardrobeDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete wardrobe'**
  String get wardrobeDeleteFailed;

  /// No description provided for @wardrobeItemsUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe items updated successfully'**
  String get wardrobeItemsUpdatedSuccess;

  /// No description provided for @wardrobeItemsUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to update wardrobe items'**
  String get wardrobeItemsUpdateFailed;

  /// No description provided for @wardrobeItemsDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe items deleted successfully'**
  String get wardrobeItemsDeletedSuccess;

  /// No description provided for @wardrobeItemsDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete wardrobe items'**
  String get wardrobeItemsDeleteFailed;

  /// No description provided for @wardrobeRenamedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe renamed successfully'**
  String get wardrobeRenamedSuccess;

  /// No description provided for @wardrobeRenameFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to rename wardrobe'**
  String get wardrobeRenameFailed;

  /// No description provided for @wardrobeAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Dresses added to wardrobe successfully'**
  String get wardrobeAddedSuccess;

  /// No description provided for @wardrobeAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to add dresses'**
  String get wardrobeAddFailed;

  /// No description provided for @wardrobeCoverUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe cover updated successfully'**
  String get wardrobeCoverUpdatedSuccess;

  /// No description provided for @wardrobeCoverUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to update wardrobe cover'**
  String get wardrobeCoverUpdateFailed;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// No description provided for @productFallbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productFallbackLabel;

  /// No description provided for @helpCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find answers to common questions'**
  String get helpCenterSubtitle;

  /// No description provided for @helpCenterBrowseByCategory.
  ///
  /// In en, this message translates to:
  /// **'Browse By Category'**
  String get helpCenterBrowseByCategory;

  /// No description provided for @helpCenterPopularQuestions.
  ///
  /// In en, this message translates to:
  /// **'Popular Questions'**
  String get helpCenterPopularQuestions;

  /// No description provided for @helpCenterCategoryOrderTracking.
  ///
  /// In en, this message translates to:
  /// **'Order & Tracking'**
  String get helpCenterCategoryOrderTracking;

  /// No description provided for @helpCenterCategoryShippingDelivery.
  ///
  /// In en, this message translates to:
  /// **'Shipping & Delivery'**
  String get helpCenterCategoryShippingDelivery;

  /// No description provided for @helpCenterCategoryAccountProfile.
  ///
  /// In en, this message translates to:
  /// **'Account & Profile'**
  String get helpCenterCategoryAccountProfile;

  /// No description provided for @helpCenterCategoryAiStylingAssistance.
  ///
  /// In en, this message translates to:
  /// **'AI Styling Assistance'**
  String get helpCenterCategoryAiStylingAssistance;

  /// No description provided for @helpCenterQuestionTrackOrder.
  ///
  /// In en, this message translates to:
  /// **'How can I track my order?'**
  String get helpCenterQuestionTrackOrder;

  /// No description provided for @helpCenterAnswerTrackOrder.
  ///
  /// In en, this message translates to:
  /// **'You can track your order from the \'My Orders\' section under your profile. Real-time updates are available 24/7.'**
  String get helpCenterAnswerTrackOrder;

  /// No description provided for @helpCenterQuestionDeliveryTime.
  ///
  /// In en, this message translates to:
  /// **'How long does delivery take?'**
  String get helpCenterQuestionDeliveryTime;

  /// No description provided for @helpCenterAnswerDeliveryTime.
  ///
  /// In en, this message translates to:
  /// **'Standard delivery usually takes 3-5 business days, while express shipping arrives within 1-2 business days.'**
  String get helpCenterAnswerDeliveryTime;

  /// No description provided for @helpCenterQuestionDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Can I change my delivery address?'**
  String get helpCenterQuestionDeliveryAddress;

  /// No description provided for @helpCenterAnswerDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Yes. You can update your delivery address before the order is shipped from the \'My Orders\' section.'**
  String get helpCenterAnswerDeliveryAddress;

  /// No description provided for @helpCenterQuestionAiStyling.
  ///
  /// In en, this message translates to:
  /// **'What is DripTalk AI Styling?'**
  String get helpCenterQuestionAiStyling;

  /// No description provided for @helpCenterAnswerAiStyling.
  ///
  /// In en, this message translates to:
  /// **'DripTalk AI Styling gives you personalized outfit recommendations, styling tips, and fashion advice based on your preferences.'**
  String get helpCenterAnswerAiStyling;

  /// No description provided for @helpCenterQuestionReturns.
  ///
  /// In en, this message translates to:
  /// **'How do returns work?'**
  String get helpCenterQuestionReturns;

  /// No description provided for @helpCenterAnswerReturns.
  ///
  /// In en, this message translates to:
  /// **'You can request a return from your order details. Eligible items can be returned within the allowed return window.'**
  String get helpCenterAnswerReturns;

  /// No description provided for @helpCenterLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to load help center.'**
  String get helpCenterLoadFailed;

  /// No description provided for @helpCenterNoCategories.
  ///
  /// In en, this message translates to:
  /// **'No help categories available right now.'**
  String get helpCenterNoCategories;

  /// No description provided for @helpCenterNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No popular questions are available for this category yet.'**
  String get helpCenterNoQuestions;

  /// Message shown when the privacy policy screen fails to load
  ///
  /// In en, this message translates to:
  /// **'Unable to load privacy policy.'**
  String get privacyPolicyLoadFailed;

  /// Message shown when the privacy policy screen has no sections to display
  ///
  /// In en, this message translates to:
  /// **'Privacy policy details are not available right now.'**
  String get privacyPolicyNoSections;

  /// Default subtitle shown below the privacy policy page title
  ///
  /// In en, this message translates to:
  /// **'Please review how we collect and protect your data.'**
  String get privacyPolicyDefaultSubtitle;

  /// No description provided for @returnPolicyLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to load return policy.'**
  String get returnPolicyLoadFailed;

  /// No description provided for @returnPolicyNoSections.
  ///
  /// In en, this message translates to:
  /// **'Return policy details are not available right now.'**
  String get returnPolicyNoSections;

  /// No description provided for @returnPolicyDefaultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Return Guidelines & Timeline'**
  String get returnPolicyDefaultSubtitle;

  /// No description provided for @returnPolicyDefaultHeading.
  ///
  /// In en, this message translates to:
  /// **'We offer a 7-day return policy for eligible items.'**
  String get returnPolicyDefaultHeading;

  /// No description provided for @returnPolicyStartAction.
  ///
  /// In en, this message translates to:
  /// **'Start A Return'**
  String get returnPolicyStartAction;

  /// Message shown when the terms and conditions screen fails to load
  ///
  /// In en, this message translates to:
  /// **'Unable to load terms & conditions.'**
  String get termsAndConditionsLoadFailed;

  /// Message shown when the terms and conditions screen has no sections to display
  ///
  /// In en, this message translates to:
  /// **'Terms & conditions details are not available right now.'**
  String get termsAndConditionsNoSections;

  /// Default subtitle shown below the terms and conditions page title
  ///
  /// In en, this message translates to:
  /// **'Please review our terms carefully'**
  String get termsAndConditionsDefaultSubtitle;

  /// No description provided for @reviewsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Review'**
  String get reviewsDeleteTitle;

  /// No description provided for @reviewsDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this review? This action can\'t be undone.'**
  String get reviewsDeleteMessage;

  /// No description provided for @reviewsWriteAction.
  ///
  /// In en, this message translates to:
  /// **'Add Review'**
  String get reviewsWriteAction;

  /// No description provided for @reviewsWriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Write Review'**
  String get reviewsWriteTitle;

  /// No description provided for @reviewsEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Review'**
  String get reviewsEditTitle;

  /// No description provided for @reviewsRatingRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating'**
  String get reviewsRatingRequired;

  /// No description provided for @reviewsTextRequired.
  ///
  /// In en, this message translates to:
  /// **'Please share your review'**
  String get reviewsTextRequired;

  /// No description provided for @reviewsInputHint.
  ///
  /// In en, this message translates to:
  /// **'Write your review here...'**
  String get reviewsInputHint;

  /// No description provided for @reviewsSubmitAction.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get reviewsSubmitAction;

  /// No description provided for @reviewsUpdateAction.
  ///
  /// In en, this message translates to:
  /// **'Update Review'**
  String get reviewsUpdateAction;

  /// No description provided for @reviewsDeliveredPrefix.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get reviewsDeliveredPrefix;

  /// No description provided for @reviewsReviewedPrefix.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get reviewsReviewedPrefix;

  /// No description provided for @reviewsPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get reviewsPendingLabel;

  /// No description provided for @reviewsFallbackComment.
  ///
  /// In en, this message translates to:
  /// **'No review added yet.'**
  String get reviewsFallbackComment;

  /// No description provided for @reviewsPromptComment.
  ///
  /// In en, this message translates to:
  /// **'Tell others what you liked or what could be better.'**
  String get reviewsPromptComment;

  /// No description provided for @reviewsRecentlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Recently'**
  String get reviewsRecentlyLabel;

  /// No description provided for @reviewsManageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your ratings and feedback'**
  String get reviewsManageSubtitle;

  /// No description provided for @reviewsStatTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get reviewsStatTotal;

  /// No description provided for @reviewsStatAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get reviewsStatAverage;

  /// No description provided for @reviewsStatPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get reviewsStatPending;

  /// No description provided for @reviewsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get reviewsFilterAll;

  /// No description provided for @reviewsFilterFiveStars.
  ///
  /// In en, this message translates to:
  /// **'5 Stars'**
  String get reviewsFilterFiveStars;

  /// No description provided for @reviewsFilterFourStars.
  ///
  /// In en, this message translates to:
  /// **'4 Stars'**
  String get reviewsFilterFourStars;

  /// No description provided for @reviewsFilterPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get reviewsFilterPending;

  /// No description provided for @reviewsEmptyFilteredTitle.
  ///
  /// In en, this message translates to:
  /// **'No reviews match this filter'**
  String get reviewsEmptyFilteredTitle;

  /// No description provided for @reviewsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get reviewsEmptyTitle;

  /// No description provided for @reviewsEmptyFilteredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try another filter to see more of your reviews.'**
  String get reviewsEmptyFilteredSubtitle;

  /// No description provided for @reviewsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your submitted reviews will appear here.'**
  String get reviewsEmptySubtitle;

  /// No description provided for @reviewsShowAllAction.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get reviewsShowAllAction;

  /// No description provided for @reviewsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to load reviews.'**
  String get reviewsLoadFailed;

  /// No description provided for @reviewsUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Review updated successfully.'**
  String get reviewsUpdateSuccess;

  /// No description provided for @reviewsUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to update review.'**
  String get reviewsUpdateFailed;

  /// No description provided for @reviewsDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Review deleted successfully.'**
  String get reviewsDeleteSuccess;

  /// No description provided for @reviewsDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete review.'**
  String get reviewsDeleteFailed;

  /// No description provided for @reviewSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Review submitted successfully.'**
  String get reviewSubmittedSuccess;

  /// No description provided for @reviewSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to submit review.'**
  String get reviewSubmitFailed;

  /// No description provided for @aiStyleInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Style Insights'**
  String get aiStyleInsightsTitle;

  /// No description provided for @aiStyleInsightsPerfectPairing.
  ///
  /// In en, this message translates to:
  /// **'Perfect Pairing'**
  String get aiStyleInsightsPerfectPairing;

  /// No description provided for @aiStyleInsightsPerfectPairingDescription.
  ///
  /// In en, this message translates to:
  /// **'Pair this piece with wide-leg trousers and a clean sneaker for a polished everyday look.'**
  String get aiStyleInsightsPerfectPairingDescription;

  /// No description provided for @aiStyleInsightsStyleTip.
  ///
  /// In en, this message translates to:
  /// **'Style Tip'**
  String get aiStyleInsightsStyleTip;

  /// No description provided for @aiStyleInsightsStyleTipDescription.
  ///
  /// In en, this message translates to:
  /// **'Balance the silhouette with minimal accessories and let the statement piece stand out.'**
  String get aiStyleInsightsStyleTipDescription;

  /// No description provided for @aiStyleInsightsTrendAlert.
  ///
  /// In en, this message translates to:
  /// **'Trend Alert'**
  String get aiStyleInsightsTrendAlert;

  /// No description provided for @aiStyleInsightsTrendAlertDescription.
  ///
  /// In en, this message translates to:
  /// **'This look is trending for modern streetwear and elevated casual styling.'**
  String get aiStyleInsightsTrendAlertDescription;

  /// No description provided for @twoFactorTokenNotFound.
  ///
  /// In en, this message translates to:
  /// **'Two-factor verification token not found.'**
  String get twoFactorTokenNotFound;

  /// No description provided for @authTokenNotFound.
  ///
  /// In en, this message translates to:
  /// **'Authentication token not found.'**
  String get authTokenNotFound;

  /// No description provided for @logoutSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully.'**
  String get logoutSuccessMessage;

  /// No description provided for @deleteAccountSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully.'**
  String get deleteAccountSuccessMessage;

  /// No description provided for @unexpectedErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedErrorOccurred;

  /// No description provided for @twoFactorEnterAuthenticatorCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from your authenticator app.'**
  String get twoFactorEnterAuthenticatorCode;

  /// No description provided for @twoFactorVerifiedSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication verified successfully.'**
  String get twoFactorVerifiedSuccessMessage;

  /// No description provided for @twoFactorVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to verify two-factor authentication.'**
  String get twoFactorVerificationFailed;

  /// No description provided for @biometricInitializeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize biometric authentication.'**
  String get biometricInitializeFailed;

  /// No description provided for @biometricUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available on this device.'**
  String get biometricUnavailable;

  /// No description provided for @biometricAuthenticateReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to sign in with biometrics.'**
  String get biometricAuthenticateReason;

  /// No description provided for @biometricSignedInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed in with biometrics.'**
  String get biometricSignedInSuccess;

  /// No description provided for @biometricSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your biometric session has expired. Please sign in again.'**
  String get biometricSessionExpired;

  /// No description provided for @biometricAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication failed.'**
  String get biometricAuthFailed;

  /// No description provided for @biometricVerifyEmailFirst.
  ///
  /// In en, this message translates to:
  /// **'Verify your email before enabling biometric login.'**
  String get biometricVerifyEmailFirst;

  /// No description provided for @biometricRefreshSessionRequired.
  ///
  /// In en, this message translates to:
  /// **'Refresh your session before using biometric login.'**
  String get biometricRefreshSessionRequired;

  /// No description provided for @biometricTokenMissingManualLogin.
  ///
  /// In en, this message translates to:
  /// **'Authentication token missing. Please log in manually.'**
  String get biometricTokenMissingManualLogin;

  /// No description provided for @biometricNoSavedSession.
  ///
  /// In en, this message translates to:
  /// **'No saved biometric session found.'**
  String get biometricNoSavedSession;

  /// No description provided for @editProfileLoadBeforeTwoFactorUpdate.
  ///
  /// In en, this message translates to:
  /// **'Load your profile before updating two-factor authentication.'**
  String get editProfileLoadBeforeTwoFactorUpdate;

  /// No description provided for @editProfileTwoFactorEnabledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication enabled successfully.'**
  String get editProfileTwoFactorEnabledSuccess;

  /// No description provided for @editProfileTwoFactorDisabledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication disabled successfully.'**
  String get editProfileTwoFactorDisabledSuccess;

  /// No description provided for @editProfileLoadBeforeTwoFactorVerify.
  ///
  /// In en, this message translates to:
  /// **'Load your profile before verifying two-factor authentication.'**
  String get editProfileLoadBeforeTwoFactorVerify;

  /// No description provided for @editProfileBiometricDisabled.
  ///
  /// In en, this message translates to:
  /// **'Biometric login disabled.'**
  String get editProfileBiometricDisabled;

  /// No description provided for @editProfileBiometricUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric login is not available on this device.'**
  String get editProfileBiometricUnavailable;

  /// No description provided for @editProfileBiometricReLogin.
  ///
  /// In en, this message translates to:
  /// **'Log in again before enabling biometric login.'**
  String get editProfileBiometricReLogin;

  /// No description provided for @editProfileBiometricPasswordLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Log in once with email and password before enabling biometric login.'**
  String get editProfileBiometricPasswordLoginRequired;

  /// No description provided for @editProfileBiometricEnabled.
  ///
  /// In en, this message translates to:
  /// **'Biometric login enabled.'**
  String get editProfileBiometricEnabled;

  /// No description provided for @backOnline.
  ///
  /// In en, this message translates to:
  /// **'Back online'**
  String get backOnline;

  /// No description provided for @searchCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Search country'**
  String get searchCountryHint;

  /// No description provided for @dashboardSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get dashboardSearchHint;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get navShop;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @homeCategoryAiPicks.
  ///
  /// In en, this message translates to:
  /// **'AI Picks'**
  String get homeCategoryAiPicks;

  /// No description provided for @homeCategoryTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get homeCategoryTrending;

  /// No description provided for @homeCategoryStreetwear.
  ///
  /// In en, this message translates to:
  /// **'Streetwear'**
  String get homeCategoryStreetwear;

  /// No description provided for @homeCategoryLuxury.
  ///
  /// In en, this message translates to:
  /// **'Luxury'**
  String get homeCategoryLuxury;

  /// No description provided for @homeCategoryCasual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get homeCategoryCasual;

  /// No description provided for @profileGuestName.
  ///
  /// In en, this message translates to:
  /// **'DripTalk User'**
  String get profileGuestName;

  /// No description provided for @profileGuestInitials.
  ///
  /// In en, this message translates to:
  /// **'DT'**
  String get profileGuestInitials;

  /// No description provided for @forgotPasswordOtpSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to send OTP'**
  String get forgotPasswordOtpSendFailed;

  /// No description provided for @resetPasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to reset password'**
  String get resetPasswordFailed;

  /// No description provided for @signupNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network Error'**
  String get signupNetworkError;

  /// No description provided for @wishlistUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to update saved items'**
  String get wishlistUpdateFailed;

  /// No description provided for @cartUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to update cart'**
  String get cartUpdateFailed;

  /// No description provided for @profileSetupDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re All Set!'**
  String get profileSetupDialogTitle;

  /// No description provided for @profileSetupDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'Your AI Stylist Is Now Trained And Ready To Help You Look Your Best.'**
  String get profileSetupDialogDescription;

  /// No description provided for @profileSetupDialogAction.
  ///
  /// In en, this message translates to:
  /// **'Start Exploring'**
  String get profileSetupDialogAction;

  /// No description provided for @recommendationsSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Personalize Your Feed'**
  String get recommendationsSheetTitle;

  /// No description provided for @recommendationsSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Selfie For Better Matches'**
  String get recommendationsSheetSubtitle;

  /// No description provided for @recommendationsSelfieHeadlineLeading.
  ///
  /// In en, this message translates to:
  /// **'Let\'s See '**
  String get recommendationsSelfieHeadlineLeading;

  /// No description provided for @recommendationsSelfieHeadlineAccent.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get recommendationsSelfieHeadlineAccent;

  /// No description provided for @recommendationsSelfieDescription.
  ///
  /// In en, this message translates to:
  /// **'A quick headshot helps us match outfits to your skin tone, hair, and features.'**
  String get recommendationsSelfieDescription;

  /// No description provided for @recommendationsTakePhotoAction.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get recommendationsTakePhotoAction;

  /// No description provided for @recommendationsTakePhotoCaption.
  ///
  /// In en, this message translates to:
  /// **'Use Camera'**
  String get recommendationsTakePhotoCaption;

  /// No description provided for @recommendationsUploadPhotoAction.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get recommendationsUploadPhotoAction;

  /// No description provided for @recommendationsUploadPhotoCaption.
  ///
  /// In en, this message translates to:
  /// **'From Gallery'**
  String get recommendationsUploadPhotoCaption;

  /// No description provided for @recommendationsPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Private & Secure. Used only for styling. Never shared.'**
  String get recommendationsPrivacyNote;

  /// No description provided for @recommendationsLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Finding your best matches...'**
  String get recommendationsLoadingMessage;

  /// No description provided for @recommendationsPhotoRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Add a photo to continue.'**
  String get recommendationsPhotoRequiredMessage;

  /// No description provided for @recommendationsLoadFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'I could not load recommendations right now. Please try again.'**
  String get recommendationsLoadFailedMessage;

  /// No description provided for @recommendationsNoDataMessage.
  ///
  /// In en, this message translates to:
  /// **'No recommendations are available right now.'**
  String get recommendationsNoDataMessage;

  /// No description provided for @recommendationsReviewProgress.
  ///
  /// In en, this message translates to:
  /// **'Outfit {current} Of {total}'**
  String recommendationsReviewProgress(int current, int total);

  /// No description provided for @recommendationsLoveAction.
  ///
  /// In en, this message translates to:
  /// **'Love it'**
  String get recommendationsLoveAction;

  /// No description provided for @recommendationsReadyLabel.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get recommendationsReadyLabel;

  /// No description provided for @recommendationsLookLabel.
  ///
  /// In en, this message translates to:
  /// **'Look {index}'**
  String recommendationsLookLabel(int index);

  /// No description provided for @recommendationsMatchLabel.
  ///
  /// In en, this message translates to:
  /// **'{score}% Match'**
  String recommendationsMatchLabel(int score);

  /// No description provided for @recommendationsPhotoReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'Front-face photo ready. Continue to generate your looks.'**
  String get recommendationsPhotoReadyMessage;

  /// No description provided for @recommendationsPhotoGuidanceMessage.
  ///
  /// In en, this message translates to:
  /// **'Use one clear front-face photo only. Side poses and group photos are not supported.'**
  String get recommendationsPhotoGuidanceMessage;

  /// No description provided for @recommendationsPhotoValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Checking that the photo is front-facing...'**
  String get recommendationsPhotoValidationMessage;

  /// Validation message shown when the uploaded recommendations selfie does not contain a detectable face
  ///
  /// In en, this message translates to:
  /// **'Use a clear front-facing photo with your full face visible.'**
  String get recommendationsPhotoNoFaceMessage;

  /// Validation message shown when the uploaded recommendations selfie contains multiple faces
  ///
  /// In en, this message translates to:
  /// **'Upload a photo with one face only.'**
  String get recommendationsPhotoMultipleFacesMessage;

  /// Validation message shown when the recommendations selfie could not be verified as usable
  ///
  /// In en, this message translates to:
  /// **'I could not verify this photo. Try another clear front-face photo.'**
  String get recommendationsPhotoVerificationFailedMessage;

  /// Validation message shown when the uploaded recommendations selfie is not front-facing enough
  ///
  /// In en, this message translates to:
  /// **'Use a straight front-face photo. Side poses are not supported.'**
  String get recommendationsPhotoSidePoseMessage;

  /// No description provided for @recommendationsTrainingTitle.
  ///
  /// In en, this message translates to:
  /// **'Train Your AI Stylist'**
  String get recommendationsTrainingTitle;

  /// No description provided for @recommendationsTrainingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Building your first outfit matches'**
  String get recommendationsTrainingSubtitle;

  /// No description provided for @recommendationsTrainingDescription.
  ///
  /// In en, this message translates to:
  /// **'We are turning your photo into a personalized look feed.'**
  String get recommendationsTrainingDescription;

  /// No description provided for @recommendationsStyleDnaTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Style DNA'**
  String get recommendationsStyleDnaTitle;

  /// No description provided for @recommendationsLooksMatchedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{total} Looks Matched Your Taste'**
  String recommendationsLooksMatchedSubtitle(int total);

  /// No description provided for @recommendationsLovedLooksHeadline.
  ///
  /// In en, this message translates to:
  /// **'You Loved {count} Looks'**
  String recommendationsLovedLooksHeadline(int count);

  /// No description provided for @recommendationsReviewedLooksHeadline.
  ///
  /// In en, this message translates to:
  /// **'You Reviewed {total} Looks'**
  String recommendationsReviewedLooksHeadline(int total);

  /// No description provided for @recommendationsSummaryLovedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Our AI has the vibe. Here\'s what made the cut.'**
  String get recommendationsSummaryLovedSubtitle;

  /// No description provided for @recommendationsSummaryReviewedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here\'s the full set of looks from your recommendation feed.'**
  String get recommendationsSummaryReviewedSubtitle;

  /// No description provided for @recommendationsVibeSignalTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Vibe Signal'**
  String get recommendationsVibeSignalTitle;

  /// No description provided for @recommendationsTryOnEligibleMessage.
  ///
  /// In en, this message translates to:
  /// **'We will generate try-on looks from the {count} saved outfit images you liked.'**
  String recommendationsTryOnEligibleMessage(int count);

  /// No description provided for @recommendationsTryOnMissingImagesMessage.
  ///
  /// In en, this message translates to:
  /// **'Your liked looks are missing usable outfit images, so try-on can\'t start yet.'**
  String get recommendationsTryOnMissingImagesMessage;

  /// No description provided for @recommendationsRetrainAction.
  ///
  /// In en, this message translates to:
  /// **'Retrain'**
  String get recommendationsRetrainAction;

  /// No description provided for @recommendationsGeneratingTitle.
  ///
  /// In en, this message translates to:
  /// **'Generating Your Looks'**
  String get recommendationsGeneratingTitle;

  /// No description provided for @recommendationsGeneratingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI try-on is matching your liked outfits'**
  String get recommendationsGeneratingSubtitle;

  /// No description provided for @recommendationsProcessingLabel.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get recommendationsProcessingLabel;

  /// No description provided for @recommendationsBuildingTryOnTitle.
  ///
  /// In en, this message translates to:
  /// **'Building your try-on photos'**
  String get recommendationsBuildingTryOnTitle;

  /// No description provided for @recommendationsTryOnUploadTimeline.
  ///
  /// In en, this message translates to:
  /// **'Uploading your selfie and liked outfit images'**
  String get recommendationsTryOnUploadTimeline;

  /// No description provided for @recommendationsTryOnFitTimeline.
  ///
  /// In en, this message translates to:
  /// **'Generating outfit overlays and body fit'**
  String get recommendationsTryOnFitTimeline;

  /// No description provided for @recommendationsTryOnRenderTimeline.
  ///
  /// In en, this message translates to:
  /// **'Rendering final try-on looks'**
  String get recommendationsTryOnRenderTimeline;

  /// No description provided for @recommendationsGeneratedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Try-On'**
  String get recommendationsGeneratedTitle;

  /// No description provided for @recommendationsGeneratedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generated from the looks you liked'**
  String get recommendationsGeneratedSubtitle;

  /// No description provided for @recommendationsDoneAction.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get recommendationsDoneAction;

  /// No description provided for @recommendationsNextLookAction.
  ///
  /// In en, this message translates to:
  /// **'Next look →'**
  String get recommendationsNextLookAction;

  /// No description provided for @recommendationsContinueChatAction.
  ///
  /// In en, this message translates to:
  /// **'Continue With Chat →'**
  String get recommendationsContinueChatAction;

  /// No description provided for @recommendationsStyledLookFallback.
  ///
  /// In en, this message translates to:
  /// **'Styled Look'**
  String get recommendationsStyledLookFallback;

  /// No description provided for @recommendationsStyleDescriptorFallback.
  ///
  /// In en, this message translates to:
  /// **'your current style'**
  String get recommendationsStyleDescriptorFallback;

  /// No description provided for @recommendationsStyleSignalEmpty.
  ///
  /// In en, this message translates to:
  /// **'We used your review to learn your taste. We\'ll keep refining your daily feed around {descriptor}.'**
  String recommendationsStyleSignalEmpty(String descriptor);

  /// No description provided for @recommendationsStyleSignalLoved.
  ///
  /// In en, this message translates to:
  /// **'You lean toward {descriptor} aesthetics. We\'ll curate your daily feed around this.'**
  String recommendationsStyleSignalLoved(String descriptor);

  /// No description provided for @recommendationsTryOnProgressFinal.
  ///
  /// In en, this message translates to:
  /// **'Final renders are being prepared. Your generated looks will open automatically when they are ready.'**
  String get recommendationsTryOnProgressFinal;

  /// No description provided for @recommendationsTryOnProgressFitting.
  ///
  /// In en, this message translates to:
  /// **'Your selfie is being fitted against each liked outfit to create realistic try-on results.'**
  String get recommendationsTryOnProgressFitting;

  /// No description provided for @recommendationsTryOnProgressPreparing.
  ///
  /// In en, this message translates to:
  /// **'We are pairing your face image with the outfits you liked and preparing the generation batch.'**
  String get recommendationsTryOnProgressPreparing;

  /// No description provided for @recommendationsTryOnProgressUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading your selected images and starting the AI try-on batch.'**
  String get recommendationsTryOnProgressUploading;

  /// No description provided for @recommendationsTryOnLooksRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Like at least one look to generate your try-on results.'**
  String get recommendationsTryOnLooksRequiredMessage;

  /// No description provided for @recommendationsTryOnFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'I could not generate your try-on looks right now. Please try again.'**
  String get recommendationsTryOnFailedMessage;

  /// No description provided for @recommendationsTryOnEmptyResultMessage.
  ///
  /// In en, this message translates to:
  /// **'Your try-on finished without any generated looks. Please try again.'**
  String get recommendationsTryOnEmptyResultMessage;

  /// No description provided for @recommendationsTryOnTimeoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Try-on generation is taking longer than expected. Please try again.'**
  String get recommendationsTryOnTimeoutMessage;

  /// No description provided for @profileSetupLoadFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to load your profile.'**
  String get profileSetupLoadFailedMessage;

  /// No description provided for @profileSetupSaveSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile setup completed successfully.'**
  String get profileSetupSaveSuccessMessage;

  /// No description provided for @profileSetupSaveFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to save your profile.'**
  String get profileSetupSaveFailedMessage;

  /// No description provided for @profileSetupNoOptionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No options available yet.'**
  String get profileSetupNoOptionsAvailable;

  /// No description provided for @profileSetupPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing your profile setup...'**
  String get profileSetupPreparing;

  /// No description provided for @profileSetupLoadFailureTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to load setup'**
  String get profileSetupLoadFailureTitle;

  /// No description provided for @profileSetupCompleteAction.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get profileSetupCompleteAction;

  /// No description provided for @profileSetupHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome To DripTalk'**
  String get profileSetupHeaderTitle;

  /// No description provided for @profileSetupHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get To Know You First'**
  String get profileSetupHeaderSubtitle;

  /// No description provided for @profileSetupStepBasicsLabel.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get profileSetupStepBasicsLabel;

  /// No description provided for @profileSetupStepBodyLabel.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get profileSetupStepBodyLabel;

  /// No description provided for @profileSetupStepSkinLabel.
  ///
  /// In en, this message translates to:
  /// **'Skin'**
  String get profileSetupStepSkinLabel;

  /// No description provided for @profileSetupStepStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get profileSetupStepStyleLabel;

  /// No description provided for @profileSetupStepHeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get profileSetupStepHeightLabel;

  /// No description provided for @profileSetupStepWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get profileSetupStepWeightLabel;

  /// No description provided for @profileSetupStepBrandsLabel.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get profileSetupStepBrandsLabel;

  /// No description provided for @profileSetupStepColorsLabel.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get profileSetupStepColorsLabel;

  /// No description provided for @profileSetupStepAvoidsLabel.
  ///
  /// In en, this message translates to:
  /// **'Avoids'**
  String get profileSetupStepAvoidsLabel;

  /// No description provided for @profileSetupStepTrainingLabel.
  ///
  /// In en, this message translates to:
  /// **'AI Training'**
  String get profileSetupStepTrainingLabel;

  /// No description provided for @profileSetupStepPhotosLabel.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get profileSetupStepPhotosLabel;

  /// No description provided for @profileSetupStepBasicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell Us About You'**
  String get profileSetupStepBasicsTitle;

  /// No description provided for @profileSetupStepBodyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Body Shape'**
  String get profileSetupStepBodyTitle;

  /// No description provided for @profileSetupStepSkinTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Skin Tone'**
  String get profileSetupStepSkinTitle;

  /// No description provided for @profileSetupStepStyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Style Identity'**
  String get profileSetupStepStyleTitle;

  /// No description provided for @profileSetupStepHeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Height'**
  String get profileSetupStepHeightTitle;

  /// No description provided for @profileSetupStepWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Weight'**
  String get profileSetupStepWeightTitle;

  /// No description provided for @profileSetupStepBrandsTitle.
  ///
  /// In en, this message translates to:
  /// **'Where Do You Like To Shop?'**
  String get profileSetupStepBrandsTitle;

  /// No description provided for @profileSetupStepColorsTitle.
  ///
  /// In en, this message translates to:
  /// **'What Colors Define Your Style?'**
  String get profileSetupStepColorsTitle;

  /// No description provided for @profileSetupStepAvoidsTitle.
  ///
  /// In en, this message translates to:
  /// **'Styles To Avoid'**
  String get profileSetupStepAvoidsTitle;

  /// No description provided for @profileSetupStepTrainingTitle.
  ///
  /// In en, this message translates to:
  /// **'Train Your AI Stylist'**
  String get profileSetupStepTrainingTitle;

  /// No description provided for @profileSetupStepPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Show Us Your Style'**
  String get profileSetupStepPhotosTitle;

  /// No description provided for @profileSetupStepBasicsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Start With The Essentials'**
  String get profileSetupStepBasicsSubtitle;

  /// No description provided for @profileSetupStepBodySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us tailor the perfect fit for you'**
  String get profileSetupStepBodySubtitle;

  /// No description provided for @profileSetupStepSkinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll find shades that flatter'**
  String get profileSetupStepSkinSubtitle;

  /// No description provided for @profileSetupStepStyleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell Us What You Love'**
  String get profileSetupStepStyleSubtitle;

  /// No description provided for @profileSetupStepHeightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For perfectly proportioned styling'**
  String get profileSetupStepHeightSubtitle;

  /// No description provided for @profileSetupStepWeightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Used only to refine your fit'**
  String get profileSetupStepWeightSubtitle;

  /// No description provided for @profileSetupStepBrandsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick your vibe - we\'ll curate your feed'**
  String get profileSetupStepBrandsSubtitle;

  /// No description provided for @profileSetupStepColorsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the shades you keep reaching for'**
  String get profileSetupStepColorsSubtitle;

  /// No description provided for @profileSetupStepAvoidsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us what\'s not your vibe'**
  String get profileSetupStepAvoidsSubtitle;

  /// No description provided for @profileSetupStepTrainingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help Us Understand Your Taste'**
  String get profileSetupStepTrainingSubtitle;

  /// No description provided for @profileSetupStepPhotosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Outfit Inspiration'**
  String get profileSetupStepPhotosSubtitle;

  /// No description provided for @profileSetupBrandsLoadFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to load brands right now.'**
  String get profileSetupBrandsLoadFailedMessage;

  /// No description provided for @profileSetupPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get profileSetupPhoneLabel;

  /// No description provided for @profileSetupPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get profileSetupPhoneHint;

  /// No description provided for @profileSetupGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileSetupGenderLabel;

  /// No description provided for @profileSetupGenderHint.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get profileSetupGenderHint;

  /// No description provided for @profileSetupDateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get profileSetupDateOfBirthLabel;

  /// No description provided for @profileSetupDateOfBirthHint.
  ///
  /// In en, this message translates to:
  /// **'01/01/2000'**
  String get profileSetupDateOfBirthHint;

  /// No description provided for @profileSetupCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get profileSetupCountryLabel;

  /// No description provided for @profileSetupCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get profileSetupCountryHint;

  /// No description provided for @profileSetupCityLabel.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get profileSetupCityLabel;

  /// No description provided for @profileSetupCityHint.
  ///
  /// In en, this message translates to:
  /// **'Select state'**
  String get profileSetupCityHint;

  /// No description provided for @profileSetupBodyTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Body Type'**
  String get profileSetupBodyTypeLabel;

  /// No description provided for @profileSetupBodyTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Select body type'**
  String get profileSetupBodyTypeHint;

  /// No description provided for @profileSetupSkinToneLabel.
  ///
  /// In en, this message translates to:
  /// **'Skin Tone'**
  String get profileSetupSkinToneLabel;

  /// No description provided for @profileSetupSkinToneHint.
  ///
  /// In en, this message translates to:
  /// **'Select skin tone'**
  String get profileSetupSkinToneHint;

  /// No description provided for @profileSetupPreferredStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred Style'**
  String get profileSetupPreferredStyleLabel;

  /// No description provided for @profileSetupBudgetMinLabel.
  ///
  /// In en, this message translates to:
  /// **'Minimum Budget'**
  String get profileSetupBudgetMinLabel;

  /// No description provided for @profileSetupBudgetMinHint.
  ///
  /// In en, this message translates to:
  /// **'5000'**
  String get profileSetupBudgetMinHint;

  /// No description provided for @profileSetupBudgetMaxLabel.
  ///
  /// In en, this message translates to:
  /// **'Maximum Budget'**
  String get profileSetupBudgetMaxLabel;

  /// No description provided for @profileSetupBudgetMaxHint.
  ///
  /// In en, this message translates to:
  /// **'15000'**
  String get profileSetupBudgetMaxHint;

  /// No description provided for @profileSetupBudgetCurrencySymbol.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get profileSetupBudgetCurrencySymbol;

  /// No description provided for @profileSetupPreferredColorsLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred Colors'**
  String get profileSetupPreferredColorsLabel;

  /// No description provided for @profileSetupPickColorsAction.
  ///
  /// In en, this message translates to:
  /// **'Pick Colors'**
  String get profileSetupPickColorsAction;

  /// No description provided for @profileSetupPreferredBrandsLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred Brands'**
  String get profileSetupPreferredBrandsLabel;

  /// No description provided for @profileSetupHeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get profileSetupHeightLabel;

  /// No description provided for @profileSetupHeightHint.
  ///
  /// In en, this message translates to:
  /// **'5ft 7in'**
  String get profileSetupHeightHint;

  /// No description provided for @profileSetupWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get profileSetupWeightLabel;

  /// No description provided for @profileSetupWeightHint.
  ///
  /// In en, this message translates to:
  /// **'40kg'**
  String get profileSetupWeightHint;

  /// No description provided for @profileSetupStyleInspirationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Style Inspirations'**
  String get profileSetupStyleInspirationsLabel;

  /// No description provided for @profileSetupStyleInspirationsHint.
  ///
  /// In en, this message translates to:
  /// **'Brad Pitt, Timothee Chalamet'**
  String get profileSetupStyleInspirationsHint;

  /// No description provided for @profileSetupAvoidedStylesLabel.
  ///
  /// In en, this message translates to:
  /// **'Avoided Styles'**
  String get profileSetupAvoidedStylesLabel;

  /// No description provided for @profileSetupAvoidedStylesHint.
  ///
  /// In en, this message translates to:
  /// **'Neon, Oversized, Loud Prints'**
  String get profileSetupAvoidedStylesHint;

  /// No description provided for @profileSetupAvoidStylesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No exclusions yet'**
  String get profileSetupAvoidStylesEmptyTitle;

  /// No description provided for @profileSetupAvoidStylesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll filter these out of every recommendation'**
  String get profileSetupAvoidStylesEmptySubtitle;

  /// No description provided for @profileSetupAvoidStylesSelectedTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} styles excluded'**
  String profileSetupAvoidStylesSelectedTitle(int count);

  /// No description provided for @profileSetupAvoidStylesSelectedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll keep these out of every recommendation'**
  String get profileSetupAvoidStylesSelectedSubtitle;

  /// No description provided for @profileSetupReplacePhotosLabel.
  ///
  /// In en, this message translates to:
  /// **'Replace existing stylist photos with this upload'**
  String get profileSetupReplacePhotosLabel;

  /// No description provided for @profileSetupMemoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Personalization Memory'**
  String get profileSetupMemoryTitle;

  /// No description provided for @profileSetupMemoryDescription.
  ///
  /// In en, this message translates to:
  /// **'These details help the stylist learn your taste over time'**
  String get profileSetupMemoryDescription;

  /// No description provided for @profileSetupChooseFiles.
  ///
  /// In en, this message translates to:
  /// **'Choose Files'**
  String get profileSetupChooseFiles;

  /// No description provided for @profileSetupChooseFilesHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to select photos from camera or gallery'**
  String get profileSetupChooseFilesHint;

  /// No description provided for @profileSetupStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Status: Complete'**
  String get profileSetupStatusTitle;

  /// No description provided for @profileSetupStatusSummary.
  ///
  /// In en, this message translates to:
  /// **'{savedCount} saved / {wardrobeCount} wardrobe items'**
  String profileSetupStatusSummary(int savedCount, int wardrobeCount);

  /// No description provided for @profileSetupSelectGenderTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get profileSetupSelectGenderTitle;

  /// No description provided for @profileSetupSelectCountryTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get profileSetupSelectCountryTitle;

  /// No description provided for @profileSetupSelectCityTitle.
  ///
  /// In en, this message translates to:
  /// **'Select State'**
  String get profileSetupSelectCityTitle;

  /// No description provided for @profileSetupSelectBodyTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Body Type'**
  String get profileSetupSelectBodyTypeTitle;

  /// No description provided for @profileSetupSelectSkinToneTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Skin Tone'**
  String get profileSetupSelectSkinToneTitle;

  /// No description provided for @profileSetupSearchCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Search country'**
  String get profileSetupSearchCountryHint;

  /// No description provided for @profileSetupSearchCityHint.
  ///
  /// In en, this message translates to:
  /// **'Search state'**
  String get profileSetupSearchCityHint;

  /// No description provided for @profileSetupSearchBrandHint.
  ///
  /// In en, this message translates to:
  /// **'Search brands'**
  String get profileSetupSearchBrandHint;

  /// No description provided for @profileSetupTapToSelectBrandsHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to select multiple brands'**
  String get profileSetupTapToSelectBrandsHint;

  /// No description provided for @profileSetupSelectedCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String profileSetupSelectedCountLabel(int count);

  /// No description provided for @profileSetupColorAddHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the add button to add this color.'**
  String get profileSetupColorAddHint;

  /// No description provided for @profileSetupClearAllAction.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get profileSetupClearAllAction;

  /// No description provided for @profileSetupSearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No matching results found.'**
  String get profileSetupSearchNoResults;

  /// No description provided for @profileSetupSelectCountryFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a country first.'**
  String get profileSetupSelectCountryFirst;

  /// No description provided for @profileSetupSeeMoreAction.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get profileSetupSeeMoreAction;

  /// No description provided for @profileSetupApplyAction.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get profileSetupApplyAction;

  /// No description provided for @profileSetupValidationPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required.'**
  String get profileSetupValidationPhone;

  /// No description provided for @profileSetupValidationGender.
  ///
  /// In en, this message translates to:
  /// **'Select a gender.'**
  String get profileSetupValidationGender;

  /// No description provided for @profileSetupValidationDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Select your date of birth.'**
  String get profileSetupValidationDateOfBirth;

  /// No description provided for @profileSetupValidationCountry.
  ///
  /// In en, this message translates to:
  /// **'Select a country.'**
  String get profileSetupValidationCountry;

  /// No description provided for @profileSetupValidationCity.
  ///
  /// In en, this message translates to:
  /// **'Select a state.'**
  String get profileSetupValidationCity;

  /// No description provided for @profileSetupValidationBodyType.
  ///
  /// In en, this message translates to:
  /// **'Select a body type.'**
  String get profileSetupValidationBodyType;

  /// No description provided for @profileSetupValidationSkinTone.
  ///
  /// In en, this message translates to:
  /// **'Select a skin tone.'**
  String get profileSetupValidationSkinTone;

  /// No description provided for @profileSetupValidationStyle.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one style.'**
  String get profileSetupValidationStyle;

  /// No description provided for @profileSetupValidationBudgetMin.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid minimum budget.'**
  String get profileSetupValidationBudgetMin;

  /// No description provided for @profileSetupValidationBudgetMax.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid maximum budget.'**
  String get profileSetupValidationBudgetMax;

  /// No description provided for @profileSetupValidationBudgetRange.
  ///
  /// In en, this message translates to:
  /// **'Maximum budget must be greater than minimum budget.'**
  String get profileSetupValidationBudgetRange;

  /// No description provided for @profileSetupValidationColor.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one color.'**
  String get profileSetupValidationColor;

  /// No description provided for @profileSetupValidationBrand.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one brand.'**
  String get profileSetupValidationBrand;

  /// No description provided for @profileSetupValidationHeight.
  ///
  /// In en, this message translates to:
  /// **'Height is required.'**
  String get profileSetupValidationHeight;

  /// No description provided for @profileSetupValidationWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight is required.'**
  String get profileSetupValidationWeight;

  /// No description provided for @profileSetupValidationInspirations.
  ///
  /// In en, this message translates to:
  /// **'Add your style inspirations.'**
  String get profileSetupValidationInspirations;

  /// No description provided for @profileSetupValidationAvoidStyles.
  ///
  /// In en, this message translates to:
  /// **'Add the styles you want to avoid.'**
  String get profileSetupValidationAvoidStyles;

  /// No description provided for @profileSetupOptionGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get profileSetupOptionGenderMale;

  /// No description provided for @profileSetupOptionGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get profileSetupOptionGenderFemale;

  /// No description provided for @profileSetupOptionGenderNonBinary.
  ///
  /// In en, this message translates to:
  /// **'Non-binary'**
  String get profileSetupOptionGenderNonBinary;

  /// No description provided for @profileSetupOptionBodyTypeAthletic.
  ///
  /// In en, this message translates to:
  /// **'Athletic'**
  String get profileSetupOptionBodyTypeAthletic;

  /// No description provided for @profileSetupOptionBodyTypeSlim.
  ///
  /// In en, this message translates to:
  /// **'Slim'**
  String get profileSetupOptionBodyTypeSlim;

  /// No description provided for @profileSetupOptionBodyTypeRegular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get profileSetupOptionBodyTypeRegular;

  /// No description provided for @profileSetupOptionBodyTypeCurvy.
  ///
  /// In en, this message translates to:
  /// **'Curvy'**
  String get profileSetupOptionBodyTypeCurvy;

  /// No description provided for @profileSetupOptionBodyTypePlusSize.
  ///
  /// In en, this message translates to:
  /// **'Plus Size'**
  String get profileSetupOptionBodyTypePlusSize;

  /// No description provided for @profileSetupOptionBodyTypeAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get profileSetupOptionBodyTypeAverage;

  /// No description provided for @profileSetupOptionBodyTypePlus.
  ///
  /// In en, this message translates to:
  /// **'Plus'**
  String get profileSetupOptionBodyTypePlus;

  /// No description provided for @profileSetupOptionBodyTypeMuscular.
  ///
  /// In en, this message translates to:
  /// **'Muscular'**
  String get profileSetupOptionBodyTypeMuscular;

  /// No description provided for @profileSetupOptionBodyTypeSlimDescription.
  ///
  /// In en, this message translates to:
  /// **'Lean & narrow'**
  String get profileSetupOptionBodyTypeSlimDescription;

  /// No description provided for @profileSetupOptionBodyTypeAthleticDescription.
  ///
  /// In en, this message translates to:
  /// **'Toned & V-shape'**
  String get profileSetupOptionBodyTypeAthleticDescription;

  /// No description provided for @profileSetupOptionBodyTypeAverageDescription.
  ///
  /// In en, this message translates to:
  /// **'Balanced Build'**
  String get profileSetupOptionBodyTypeAverageDescription;

  /// No description provided for @profileSetupOptionBodyTypeCurvyDescription.
  ///
  /// In en, this message translates to:
  /// **'Hourglass Shape'**
  String get profileSetupOptionBodyTypeCurvyDescription;

  /// No description provided for @profileSetupOptionBodyTypePlusDescription.
  ///
  /// In en, this message translates to:
  /// **'Fuller Figure'**
  String get profileSetupOptionBodyTypePlusDescription;

  /// No description provided for @profileSetupOptionBodyTypeMuscularDescription.
  ///
  /// In en, this message translates to:
  /// **'Built & Strong'**
  String get profileSetupOptionBodyTypeMuscularDescription;

  /// No description provided for @profileSetupOptionSkinTonePorcelain.
  ///
  /// In en, this message translates to:
  /// **'Porcelain'**
  String get profileSetupOptionSkinTonePorcelain;

  /// No description provided for @profileSetupOptionSkinToneIvory.
  ///
  /// In en, this message translates to:
  /// **'Ivory'**
  String get profileSetupOptionSkinToneIvory;

  /// No description provided for @profileSetupOptionSkinToneLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get profileSetupOptionSkinToneLight;

  /// No description provided for @profileSetupOptionSkinToneBeige.
  ///
  /// In en, this message translates to:
  /// **'Beige'**
  String get profileSetupOptionSkinToneBeige;

  /// No description provided for @profileSetupOptionSkinToneHoney.
  ///
  /// In en, this message translates to:
  /// **'Honey'**
  String get profileSetupOptionSkinToneHoney;

  /// No description provided for @profileSetupOptionSkinToneCaramel.
  ///
  /// In en, this message translates to:
  /// **'Caramel'**
  String get profileSetupOptionSkinToneCaramel;

  /// No description provided for @profileSetupOptionSkinToneMahogany.
  ///
  /// In en, this message translates to:
  /// **'Mahogany'**
  String get profileSetupOptionSkinToneMahogany;

  /// No description provided for @profileSetupOptionSkinToneEspresso.
  ///
  /// In en, this message translates to:
  /// **'Espresso'**
  String get profileSetupOptionSkinToneEspresso;

  /// No description provided for @profileSetupOptionSkinTonePorcelainDescription.
  ///
  /// In en, this message translates to:
  /// **'Cool Undertone'**
  String get profileSetupOptionSkinTonePorcelainDescription;

  /// No description provided for @profileSetupOptionSkinToneIvoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Warm Undertone'**
  String get profileSetupOptionSkinToneIvoryDescription;

  /// No description provided for @profileSetupOptionSkinToneLightDescription.
  ///
  /// In en, this message translates to:
  /// **'Neutral Undertone'**
  String get profileSetupOptionSkinToneLightDescription;

  /// No description provided for @profileSetupOptionSkinToneBeigeDescription.
  ///
  /// In en, this message translates to:
  /// **'Warm Undertone'**
  String get profileSetupOptionSkinToneBeigeDescription;

  /// No description provided for @profileSetupOptionSkinToneHoneyDescription.
  ///
  /// In en, this message translates to:
  /// **'Warm Undertone'**
  String get profileSetupOptionSkinToneHoneyDescription;

  /// No description provided for @profileSetupOptionSkinToneCaramelDescription.
  ///
  /// In en, this message translates to:
  /// **'Warm Undertone'**
  String get profileSetupOptionSkinToneCaramelDescription;

  /// No description provided for @profileSetupOptionSkinToneMahoganyDescription.
  ///
  /// In en, this message translates to:
  /// **'Warm Undertone'**
  String get profileSetupOptionSkinToneMahoganyDescription;

  /// No description provided for @profileSetupOptionSkinToneEspressoDescription.
  ///
  /// In en, this message translates to:
  /// **'Warm Undertone'**
  String get profileSetupOptionSkinToneEspressoDescription;

  /// No description provided for @profileSetupSkinToneInfoMessage.
  ///
  /// In en, this message translates to:
  /// **'Your tone helps us suggest hues that complement, never clash.'**
  String get profileSetupSkinToneInfoMessage;

  /// No description provided for @profileSetupOptionAvoidStyleFormal.
  ///
  /// In en, this message translates to:
  /// **'Formal'**
  String get profileSetupOptionAvoidStyleFormal;

  /// No description provided for @profileSetupOptionAvoidStyleStreetwears.
  ///
  /// In en, this message translates to:
  /// **'Streetwears'**
  String get profileSetupOptionAvoidStyleStreetwears;

  /// No description provided for @profileSetupOptionAvoidStyleCasual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get profileSetupOptionAvoidStyleCasual;

  /// No description provided for @profileSetupOptionAvoidStyleLuxury.
  ///
  /// In en, this message translates to:
  /// **'Luxury'**
  String get profileSetupOptionAvoidStyleLuxury;

  /// No description provided for @profileSetupOptionAvoidStyleVintage.
  ///
  /// In en, this message translates to:
  /// **'Vintage'**
  String get profileSetupOptionAvoidStyleVintage;

  /// No description provided for @profileSetupOptionAvoidStyleSporty.
  ///
  /// In en, this message translates to:
  /// **'Sporty'**
  String get profileSetupOptionAvoidStyleSporty;

  /// No description provided for @profileSetupOptionAvoidStyleMinimalist.
  ///
  /// In en, this message translates to:
  /// **'Minimalist'**
  String get profileSetupOptionAvoidStyleMinimalist;

  /// No description provided for @profileSetupOptionAvoidStyleRomantic.
  ///
  /// In en, this message translates to:
  /// **'Romantic'**
  String get profileSetupOptionAvoidStyleRomantic;

  /// No description provided for @profileSetupOptionAvoidStyleGothic.
  ///
  /// In en, this message translates to:
  /// **'Gothic'**
  String get profileSetupOptionAvoidStyleGothic;

  /// No description provided for @profileSetupOptionAvoidStyleBohemian.
  ///
  /// In en, this message translates to:
  /// **'Bohemian'**
  String get profileSetupOptionAvoidStyleBohemian;

  /// No description provided for @profileSetupOptionAvoidStyleMaximalist.
  ///
  /// In en, this message translates to:
  /// **'Maximalist'**
  String get profileSetupOptionAvoidStyleMaximalist;

  /// No description provided for @profileSetupOptionAvoidStyleCottagecore.
  ///
  /// In en, this message translates to:
  /// **'Cottagecore'**
  String get profileSetupOptionAvoidStyleCottagecore;

  /// No description provided for @profileSetupOptionAvoidStyleAthleisure.
  ///
  /// In en, this message translates to:
  /// **'Athleisure'**
  String get profileSetupOptionAvoidStyleAthleisure;

  /// No description provided for @profileSetupOptionAvoidStylePreppy.
  ///
  /// In en, this message translates to:
  /// **'Preppy'**
  String get profileSetupOptionAvoidStylePreppy;

  /// No description provided for @profileSetupOptionAvoidStyleBeach.
  ///
  /// In en, this message translates to:
  /// **'Beach'**
  String get profileSetupOptionAvoidStyleBeach;

  /// No description provided for @profileSetupOptionAvoidStyleGrunge.
  ///
  /// In en, this message translates to:
  /// **'Grunge'**
  String get profileSetupOptionAvoidStyleGrunge;

  /// No description provided for @profileSetupOptionAvoidStyleSoftGirl.
  ///
  /// In en, this message translates to:
  /// **'Soft Girl'**
  String get profileSetupOptionAvoidStyleSoftGirl;

  /// No description provided for @profileSetupOptionStyleFormal.
  ///
  /// In en, this message translates to:
  /// **'Formal'**
  String get profileSetupOptionStyleFormal;

  /// No description provided for @profileSetupOptionStyleStreetwear.
  ///
  /// In en, this message translates to:
  /// **'Streetwear'**
  String get profileSetupOptionStyleStreetwear;

  /// No description provided for @profileSetupOptionStyleCasual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get profileSetupOptionStyleCasual;

  /// No description provided for @profileSetupOptionStyleLuxury.
  ///
  /// In en, this message translates to:
  /// **'Luxury'**
  String get profileSetupOptionStyleLuxury;

  /// No description provided for @profileSetupOptionStyleVintage.
  ///
  /// In en, this message translates to:
  /// **'Vintage'**
  String get profileSetupOptionStyleVintage;

  /// No description provided for @profileSetupOptionStyleSporty.
  ///
  /// In en, this message translates to:
  /// **'Sporty'**
  String get profileSetupOptionStyleSporty;

  /// No description provided for @profileSetupOptionStyleBohemian.
  ///
  /// In en, this message translates to:
  /// **'Bohemian'**
  String get profileSetupOptionStyleBohemian;

  /// No description provided for @profileSetupOptionStyleMinimalist.
  ///
  /// In en, this message translates to:
  /// **'Minimalist'**
  String get profileSetupOptionStyleMinimalist;

  /// No description provided for @profileSetupOptionColorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get profileSetupOptionColorBlue;

  /// No description provided for @profileSetupOptionColorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get profileSetupOptionColorRed;

  /// No description provided for @profileSetupOptionColorBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get profileSetupOptionColorBlack;

  /// No description provided for @profileSetupOptionColorWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get profileSetupOptionColorWhite;

  /// No description provided for @profileSetupOptionColorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get profileSetupOptionColorGreen;

  /// No description provided for @profileSetupOptionColorWine.
  ///
  /// In en, this message translates to:
  /// **'Wine'**
  String get profileSetupOptionColorWine;

  /// No description provided for @profileSetupOptionColorNavy.
  ///
  /// In en, this message translates to:
  /// **'Navy'**
  String get profileSetupOptionColorNavy;

  /// No description provided for @profileSetupOptionColorBeige.
  ///
  /// In en, this message translates to:
  /// **'Beige'**
  String get profileSetupOptionColorBeige;

  /// No description provided for @profileSetupOptionColorBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get profileSetupOptionColorBrown;

  /// No description provided for @profileSetupOptionColorGray.
  ///
  /// In en, this message translates to:
  /// **'Gray'**
  String get profileSetupOptionColorGray;

  /// No description provided for @profileSetupOptionColorPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get profileSetupOptionColorPurple;

  /// No description provided for @profileSetupOptionBrandNike.
  ///
  /// In en, this message translates to:
  /// **'Nike'**
  String get profileSetupOptionBrandNike;

  /// No description provided for @profileSetupOptionBrandGucci.
  ///
  /// In en, this message translates to:
  /// **'Gucci'**
  String get profileSetupOptionBrandGucci;

  /// No description provided for @profileSetupOptionBrandPuma.
  ///
  /// In en, this message translates to:
  /// **'Puma'**
  String get profileSetupOptionBrandPuma;

  /// No description provided for @profileSetupOptionBrandPrada.
  ///
  /// In en, this message translates to:
  /// **'Prada'**
  String get profileSetupOptionBrandPrada;

  /// No description provided for @profileSetupOptionBrandZara.
  ///
  /// In en, this message translates to:
  /// **'Zara'**
  String get profileSetupOptionBrandZara;

  /// No description provided for @profileSetupOptionBrandAdidas.
  ///
  /// In en, this message translates to:
  /// **'Adidas'**
  String get profileSetupOptionBrandAdidas;

  /// No description provided for @profileSetupOptionBrandLouisVuitton.
  ///
  /// In en, this message translates to:
  /// **'Louis Vuitton'**
  String get profileSetupOptionBrandLouisVuitton;

  /// No description provided for @profileSetupOptionBrandBalenciaga.
  ///
  /// In en, this message translates to:
  /// **'Balenciaga'**
  String get profileSetupOptionBrandBalenciaga;

  /// No description provided for @profileSetupOptionBrandHm.
  ///
  /// In en, this message translates to:
  /// **'H&M'**
  String get profileSetupOptionBrandHm;

  /// No description provided for @profileSetupOptionCountryPakistan.
  ///
  /// In en, this message translates to:
  /// **'Pakistan'**
  String get profileSetupOptionCountryPakistan;

  /// No description provided for @profileSetupOptionCountryUnitedStates.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get profileSetupOptionCountryUnitedStates;

  /// No description provided for @profileSetupOptionCountryUnitedKingdom.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get profileSetupOptionCountryUnitedKingdom;

  /// No description provided for @profileSetupOptionCountryUnitedArabEmirates.
  ///
  /// In en, this message translates to:
  /// **'United Arab Emirates'**
  String get profileSetupOptionCountryUnitedArabEmirates;

  /// No description provided for @profileSetupOptionCountryCanada.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get profileSetupOptionCountryCanada;

  /// No description provided for @profileSetupOptionCityLahore.
  ///
  /// In en, this message translates to:
  /// **'Lahore'**
  String get profileSetupOptionCityLahore;

  /// No description provided for @profileSetupOptionCityKarachi.
  ///
  /// In en, this message translates to:
  /// **'Karachi'**
  String get profileSetupOptionCityKarachi;

  /// No description provided for @profileSetupOptionCityIslamabad.
  ///
  /// In en, this message translates to:
  /// **'Islamabad'**
  String get profileSetupOptionCityIslamabad;

  /// No description provided for @profileSetupOptionCityRawalpindi.
  ///
  /// In en, this message translates to:
  /// **'Rawalpindi'**
  String get profileSetupOptionCityRawalpindi;

  /// No description provided for @profileSetupOptionCityNewYork.
  ///
  /// In en, this message translates to:
  /// **'New York'**
  String get profileSetupOptionCityNewYork;

  /// No description provided for @profileSetupOptionCityLosAngeles.
  ///
  /// In en, this message translates to:
  /// **'Los Angeles'**
  String get profileSetupOptionCityLosAngeles;

  /// No description provided for @profileSetupOptionCityChicago.
  ///
  /// In en, this message translates to:
  /// **'Chicago'**
  String get profileSetupOptionCityChicago;

  /// No description provided for @profileSetupOptionCityHouston.
  ///
  /// In en, this message translates to:
  /// **'Houston'**
  String get profileSetupOptionCityHouston;

  /// No description provided for @profileSetupOptionCityLondon.
  ///
  /// In en, this message translates to:
  /// **'London'**
  String get profileSetupOptionCityLondon;

  /// No description provided for @profileSetupOptionCityManchester.
  ///
  /// In en, this message translates to:
  /// **'Manchester'**
  String get profileSetupOptionCityManchester;

  /// No description provided for @profileSetupOptionCityBirmingham.
  ///
  /// In en, this message translates to:
  /// **'Birmingham'**
  String get profileSetupOptionCityBirmingham;

  /// No description provided for @profileSetupOptionCityLeeds.
  ///
  /// In en, this message translates to:
  /// **'Leeds'**
  String get profileSetupOptionCityLeeds;

  /// No description provided for @profileSetupOptionCityDubai.
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get profileSetupOptionCityDubai;

  /// No description provided for @profileSetupOptionCityAbuDhabi.
  ///
  /// In en, this message translates to:
  /// **'Abu Dhabi'**
  String get profileSetupOptionCityAbuDhabi;

  /// No description provided for @profileSetupOptionCitySharjah.
  ///
  /// In en, this message translates to:
  /// **'Sharjah'**
  String get profileSetupOptionCitySharjah;

  /// No description provided for @profileSetupOptionCityAjman.
  ///
  /// In en, this message translates to:
  /// **'Ajman'**
  String get profileSetupOptionCityAjman;

  /// No description provided for @profileSetupOptionCityToronto.
  ///
  /// In en, this message translates to:
  /// **'Toronto'**
  String get profileSetupOptionCityToronto;

  /// No description provided for @profileSetupOptionCityVancouver.
  ///
  /// In en, this message translates to:
  /// **'Vancouver'**
  String get profileSetupOptionCityVancouver;

  /// No description provided for @profileSetupOptionCityMontreal.
  ///
  /// In en, this message translates to:
  /// **'Montreal'**
  String get profileSetupOptionCityMontreal;

  /// No description provided for @profileSetupOptionCityCalgary.
  ///
  /// In en, this message translates to:
  /// **'Calgary'**
  String get profileSetupOptionCityCalgary;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
