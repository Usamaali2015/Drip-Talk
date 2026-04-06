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

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

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
