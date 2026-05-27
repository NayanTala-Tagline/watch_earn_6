import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Cash'**
  String get appTitle;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Daily Cash'**
  String get appName;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @soundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get soundEffects;

  /// No description provided for @appSounds.
  ///
  /// In en, this message translates to:
  /// **'App sounds'**
  String get appSounds;

  /// No description provided for @hapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get hapticFeedback;

  /// No description provided for @vibrationOnTap.
  ///
  /// In en, this message translates to:
  /// **'Vibration on tap'**
  String get vibrationOnTap;

  /// No description provided for @dailyCash.
  ///
  /// In en, this message translates to:
  /// **'Daily Cash'**
  String get dailyCash;

  /// No description provided for @watch.
  ///
  /// In en, this message translates to:
  /// **'WATCH'**
  String get watch;

  /// No description provided for @earn.
  ///
  /// In en, this message translates to:
  /// **'EARN'**
  String get earn;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'PLAY'**
  String get play;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @signInToAccessWallet.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your wallet'**
  String get signInToAccessWallet;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @byContYouAgree.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our '**
  String get byContYouAgree;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get terms;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @andSymbol.
  ///
  /// In en, this message translates to:
  /// **' & '**
  String get andSymbol;

  /// No description provided for @onboardingOneTitle.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get onboardingOneTitle;

  /// No description provided for @onboardingOneDesc.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Watch & Earn – Turn Your Time into Rewards!'**
  String get onboardingOneDesc;

  /// No description provided for @onboardingTwoTitle.
  ///
  /// In en, this message translates to:
  /// **'Increase Balance'**
  String get onboardingTwoTitle;

  /// No description provided for @onboardingTwoDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose ads, earn bonuses, increase your balance'**
  String get onboardingTwoDesc;

  /// No description provided for @onboardingThreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Watch & Earn'**
  String get onboardingThreeTitle;

  /// No description provided for @onboardingThreeDesc.
  ///
  /// In en, this message translates to:
  /// **'The longer you watch - the more you earn'**
  String get onboardingThreeDesc;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// No description provided for @referAndEarn.
  ///
  /// In en, this message translates to:
  /// **'Refer & Earn'**
  String get referAndEarn;

  /// No description provided for @myWallet.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get myWallet;

  /// No description provided for @shareAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Share & Support'**
  String get shareAndSupport;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? Do you want to sign out?'**
  String get signOutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone. All your data will be permanently deleted.'**
  String get deleteAccountConfirmMessage;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @pressBackToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get pressBackToExit;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @minWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Min withdrawal : \${value}'**
  String minWithdrawal(Object value);

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// No description provided for @dailyCheckinReward.
  ///
  /// In en, this message translates to:
  /// **'Daily Check-in Reward'**
  String get dailyCheckinReward;

  /// No description provided for @claimReward.
  ///
  /// In en, this message translates to:
  /// **'Claim Reward'**
  String get claimReward;

  /// No description provided for @rewardClaimed.
  ///
  /// In en, this message translates to:
  /// **'Reward Claimed'**
  String get rewardClaimed;

  /// No description provided for @earnRewards.
  ///
  /// In en, this message translates to:
  /// **'Earn Rewards'**
  String get earnRewards;

  /// No description provided for @topEarningOpportunities.
  ///
  /// In en, this message translates to:
  /// **'Top Earning Opportunities'**
  String get topEarningOpportunities;

  /// No description provided for @howItWork.
  ///
  /// In en, this message translates to:
  /// **'How it work'**
  String get howItWork;

  /// No description provided for @learnToEarn.
  ///
  /// In en, this message translates to:
  /// **'Learn to Earn'**
  String get learnToEarn;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @xp.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get xp;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
  String get howItWorks;

  /// No description provided for @readyToStartEarning.
  ///
  /// In en, this message translates to:
  /// **'Ready to Start Earning?'**
  String get readyToStartEarning;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @visitWebsites.
  ///
  /// In en, this message translates to:
  /// **'Visit Websites'**
  String get visitWebsites;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @checkAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check Answer'**
  String get checkAnswer;

  /// No description provided for @rewardsAndBonus.
  ///
  /// In en, this message translates to:
  /// **'Rewards & Bonus'**
  String get rewardsAndBonus;

  /// No description provided for @yourReferralCode.
  ///
  /// In en, this message translates to:
  /// **'Your Referral Code'**
  String get yourReferralCode;

  /// No description provided for @linkAccountForCode.
  ///
  /// In en, this message translates to:
  /// **'Link Account for Code'**
  String get linkAccountForCode;

  /// No description provided for @shareYourCodeAndEarn.
  ///
  /// In en, this message translates to:
  /// **'Share Your Code & Earn'**
  String get shareYourCodeAndEarn;

  /// No description provided for @enterReferralCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Referral Code'**
  String get enterReferralCode;

  /// No description provided for @referralCodeApplied.
  ///
  /// In en, this message translates to:
  /// **'Referral Code Applied'**
  String get referralCodeApplied;

  /// No description provided for @enterFriendsCode.
  ///
  /// In en, this message translates to:
  /// **'Enter friend\'s code'**
  String get enterFriendsCode;

  /// No description provided for @pleaseEnterReferralCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter referral code'**
  String get pleaseEnterReferralCode;

  /// No description provided for @codeApplied.
  ///
  /// In en, this message translates to:
  /// **'Code Applied'**
  String get codeApplied;

  /// No description provided for @rateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rateUs;

  /// No description provided for @thanksForRating.
  ///
  /// In en, this message translates to:
  /// **'Thanks for Rating!'**
  String get thanksForRating;

  /// No description provided for @yourFeedbackMeansWorld.
  ///
  /// In en, this message translates to:
  /// **'Your feedback means the world to us'**
  String get yourFeedbackMeansWorld;

  /// No description provided for @loveOurApp.
  ///
  /// In en, this message translates to:
  /// **'Love our app? Share your feedback!'**
  String get loveOurApp;

  /// No description provided for @rateAndGetReward.
  ///
  /// In en, this message translates to:
  /// **'Rate & Get Reward'**
  String get rateAndGetReward;

  /// No description provided for @youAlreadyRatedApp.
  ///
  /// In en, this message translates to:
  /// **'You already rated the app'**
  String get youAlreadyRatedApp;

  /// No description provided for @linkYourAccountToStartEarning.
  ///
  /// In en, this message translates to:
  /// **'Link your account to start earning'**
  String get linkYourAccountToStartEarning;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get howCanWeHelp;

  /// No description provided for @supportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send us your question or issue and our team will respond shortly.'**
  String get supportSubtitle;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @brieflyDescribeIssue.
  ///
  /// In en, this message translates to:
  /// **'Briefly describe your issue'**
  String get brieflyDescribeIssue;

  /// No description provided for @tellUsMore.
  ///
  /// In en, this message translates to:
  /// **'Tell us more about what happened so we can help you better.'**
  String get tellUsMore;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @supportNote.
  ///
  /// In en, this message translates to:
  /// **'We typically reply within 24-48 hours. Your account info is sent automatically with the request.'**
  String get supportNote;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterTitle;

  /// No description provided for @titleTooShort.
  ///
  /// In en, this message translates to:
  /// **'Title is too short'**
  String get titleTooShort;

  /// No description provided for @pleaseEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get pleaseEnterDescription;

  /// No description provided for @pleaseProvideMoreDetail.
  ///
  /// In en, this message translates to:
  /// **'Please provide a bit more detail'**
  String get pleaseProvideMoreDetail;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @linkGoogleAccount.
  ///
  /// In en, this message translates to:
  /// **'Link Google Account'**
  String get linkGoogleAccount;

  /// No description provided for @coins.
  ///
  /// In en, this message translates to:
  /// **'Coins'**
  String get coins;

  /// No description provided for @googleAccountLinked.
  ///
  /// In en, this message translates to:
  /// **'Google account linked successfully!'**
  String get googleAccountLinked;

  /// No description provided for @pullDownToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh!'**
  String get pullDownToRefresh;

  /// No description provided for @refreshIn.
  ///
  /// In en, this message translates to:
  /// **'Refresh in '**
  String get refreshIn;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @crypto.
  ///
  /// In en, this message translates to:
  /// **'Crypto'**
  String get crypto;

  /// No description provided for @giftCards.
  ///
  /// In en, this message translates to:
  /// **'Gift Cards'**
  String get giftCards;

  /// No description provided for @game_credits.
  ///
  /// In en, this message translates to:
  /// **'Game Credits'**
  String get game_credits;

  /// No description provided for @paypal.
  ///
  /// In en, this message translates to:
  /// **'PayPal'**
  String get paypal;

  /// No description provided for @enterPaypalEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter PayPal Email'**
  String get enterPaypalEmail;

  /// No description provided for @wise.
  ///
  /// In en, this message translates to:
  /// **'Wise'**
  String get wise;

  /// No description provided for @emailIban.
  ///
  /// In en, this message translates to:
  /// **'Email / IBAN'**
  String get emailIban;

  /// No description provided for @payoneer.
  ///
  /// In en, this message translates to:
  /// **'Payoneer'**
  String get payoneer;

  /// No description provided for @payoneerEmail.
  ///
  /// In en, this message translates to:
  /// **'Payoneer Email'**
  String get payoneerEmail;

  /// No description provided for @skrill.
  ///
  /// In en, this message translates to:
  /// **'Skrill'**
  String get skrill;

  /// No description provided for @skrillEmail.
  ///
  /// In en, this message translates to:
  /// **'Skrill Email'**
  String get skrillEmail;

  /// No description provided for @applePay.
  ///
  /// In en, this message translates to:
  /// **'Apple Pay'**
  String get applePay;

  /// No description provided for @appleId.
  ///
  /// In en, this message translates to:
  /// **'Apple ID'**
  String get appleId;

  /// No description provided for @googleWallet.
  ///
  /// In en, this message translates to:
  /// **'Google Wallet'**
  String get googleWallet;

  /// No description provided for @googlePayNumber.
  ///
  /// In en, this message translates to:
  /// **'Google Pay Number'**
  String get googlePayNumber;

  /// No description provided for @samsungWallet.
  ///
  /// In en, this message translates to:
  /// **'Samsung Wallet'**
  String get samsungWallet;

  /// No description provided for @samsungPayId.
  ///
  /// In en, this message translates to:
  /// **'Samsung Pay ID'**
  String get samsungPayId;

  /// No description provided for @wellsFargo.
  ///
  /// In en, this message translates to:
  /// **'Wells Fargo'**
  String get wellsFargo;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @alipay.
  ///
  /// In en, this message translates to:
  /// **'Alipay'**
  String get alipay;

  /// No description provided for @alipayId.
  ///
  /// In en, this message translates to:
  /// **'Alipay ID'**
  String get alipayId;

  /// No description provided for @wechatPay.
  ///
  /// In en, this message translates to:
  /// **'WeChat Pay'**
  String get wechatPay;

  /// No description provided for @wechatId.
  ///
  /// In en, this message translates to:
  /// **'WeChat ID'**
  String get wechatId;

  /// No description provided for @upi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get upi;

  /// No description provided for @upiId.
  ///
  /// In en, this message translates to:
  /// **'UPI ID (vpa)'**
  String get upiId;

  /// No description provided for @phonepe.
  ///
  /// In en, this message translates to:
  /// **'PhonePe'**
  String get phonepe;

  /// No description provided for @phonepeNumber.
  ///
  /// In en, this message translates to:
  /// **'PhonePe Number'**
  String get phonepeNumber;

  /// No description provided for @paytm.
  ///
  /// In en, this message translates to:
  /// **'Paytm'**
  String get paytm;

  /// No description provided for @paytmNumber.
  ///
  /// In en, this message translates to:
  /// **'Paytm Number'**
  String get paytmNumber;

  /// No description provided for @gcash.
  ///
  /// In en, this message translates to:
  /// **'GCash'**
  String get gcash;

  /// No description provided for @gcashNumber.
  ///
  /// In en, this message translates to:
  /// **'GCash Number'**
  String get gcashNumber;

  /// No description provided for @grabpay.
  ///
  /// In en, this message translates to:
  /// **'GrabPay'**
  String get grabpay;

  /// No description provided for @grabRegisteredNumber.
  ///
  /// In en, this message translates to:
  /// **'Grab Registered Number'**
  String get grabRegisteredNumber;

  /// No description provided for @kakaopay.
  ///
  /// In en, this message translates to:
  /// **'KakaoPay'**
  String get kakaopay;

  /// No description provided for @kakaoId.
  ///
  /// In en, this message translates to:
  /// **'Kakao ID'**
  String get kakaoId;

  /// No description provided for @paypay.
  ///
  /// In en, this message translates to:
  /// **'PayPay'**
  String get paypay;

  /// No description provided for @paypayId.
  ///
  /// In en, this message translates to:
  /// **'PayPay ID'**
  String get paypayId;

  /// No description provided for @easypaisa.
  ///
  /// In en, this message translates to:
  /// **'Easypaisa'**
  String get easypaisa;

  /// No description provided for @easypaisaNumber.
  ///
  /// In en, this message translates to:
  /// **'Easypaisa Number'**
  String get easypaisaNumber;

  /// No description provided for @sadapay.
  ///
  /// In en, this message translates to:
  /// **'SadaPay'**
  String get sadapay;

  /// No description provided for @sadapayAccount.
  ///
  /// In en, this message translates to:
  /// **'SadaPay Account'**
  String get sadapayAccount;

  /// No description provided for @bkash.
  ///
  /// In en, this message translates to:
  /// **'bKash'**
  String get bkash;

  /// No description provided for @bkashNumber.
  ///
  /// In en, this message translates to:
  /// **'bKash Number'**
  String get bkashNumber;

  /// No description provided for @callfin.
  ///
  /// In en, this message translates to:
  /// **'CallFin'**
  String get callfin;

  /// No description provided for @callfinNumber.
  ///
  /// In en, this message translates to:
  /// **'CallFin Number'**
  String get callfinNumber;

  /// No description provided for @revolut.
  ///
  /// In en, this message translates to:
  /// **'Revolut'**
  String get revolut;

  /// No description provided for @revtagIban.
  ///
  /// In en, this message translates to:
  /// **'Revtag / IBAN'**
  String get revtagIban;

  /// No description provided for @monzo.
  ///
  /// In en, this message translates to:
  /// **'Monzo'**
  String get monzo;

  /// No description provided for @accountSortcode.
  ///
  /// In en, this message translates to:
  /// **'Account / Sort Code'**
  String get accountSortcode;

  /// No description provided for @n26.
  ///
  /// In en, this message translates to:
  /// **'N26'**
  String get n26;

  /// No description provided for @iban.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get iban;

  /// No description provided for @bunq.
  ///
  /// In en, this message translates to:
  /// **'Bunq'**
  String get bunq;

  /// No description provided for @ibanEmail.
  ///
  /// In en, this message translates to:
  /// **'IBAN / Email'**
  String get ibanEmail;

  /// No description provided for @starlingBank.
  ///
  /// In en, this message translates to:
  /// **'Starling Bank'**
  String get starlingBank;

  /// No description provided for @ideal.
  ///
  /// In en, this message translates to:
  /// **'iDEAL'**
  String get ideal;

  /// No description provided for @tikkie.
  ///
  /// In en, this message translates to:
  /// **'Tikkie'**
  String get tikkie;

  /// No description provided for @tikkieLinkNumber.
  ///
  /// In en, this message translates to:
  /// **'Tikkie Link/Number'**
  String get tikkieLinkNumber;

  /// No description provided for @vipps.
  ///
  /// In en, this message translates to:
  /// **'Vipps'**
  String get vipps;

  /// No description provided for @vippsNumber.
  ///
  /// In en, this message translates to:
  /// **'Vipps Number'**
  String get vippsNumber;

  /// No description provided for @mobilePay.
  ///
  /// In en, this message translates to:
  /// **'MobilePay'**
  String get mobilePay;

  /// No description provided for @mobilepayNumber.
  ///
  /// In en, this message translates to:
  /// **'MobilePay Number'**
  String get mobilepayNumber;

  /// No description provided for @swish.
  ///
  /// In en, this message translates to:
  /// **'Swish'**
  String get swish;

  /// No description provided for @swishNumber.
  ///
  /// In en, this message translates to:
  /// **'Swish Number'**
  String get swishNumber;

  /// No description provided for @blik.
  ///
  /// In en, this message translates to:
  /// **'BLIK'**
  String get blik;

  /// No description provided for @blikCode.
  ///
  /// In en, this message translates to:
  /// **'BLIK Code'**
  String get blikCode;

  /// No description provided for @lydia.
  ///
  /// In en, this message translates to:
  /// **'Lydia'**
  String get lydia;

  /// No description provided for @lydiaNumber.
  ///
  /// In en, this message translates to:
  /// **'Lydia Number'**
  String get lydiaNumber;

  /// No description provided for @paylib.
  ///
  /// In en, this message translates to:
  /// **'PayLib'**
  String get paylib;

  /// No description provided for @paylibNumber.
  ///
  /// In en, this message translates to:
  /// **'PayLib Number'**
  String get paylibNumber;

  /// No description provided for @twint.
  ///
  /// In en, this message translates to:
  /// **'Twint'**
  String get twint;

  /// No description provided for @twintNumber.
  ///
  /// In en, this message translates to:
  /// **'Twint Number'**
  String get twintNumber;

  /// No description provided for @satispay.
  ///
  /// In en, this message translates to:
  /// **'Satispay'**
  String get satispay;

  /// No description provided for @satispayNumber.
  ///
  /// In en, this message translates to:
  /// **'Satispay Number'**
  String get satispayNumber;

  /// No description provided for @iyzico.
  ///
  /// In en, this message translates to:
  /// **'iyzico'**
  String get iyzico;

  /// No description provided for @accountId.
  ///
  /// In en, this message translates to:
  /// **'Account ID'**
  String get accountId;

  /// No description provided for @mpesa.
  ///
  /// In en, this message translates to:
  /// **'M-Pesa'**
  String get mpesa;

  /// No description provided for @mpesaNumber.
  ///
  /// In en, this message translates to:
  /// **'M-Pesa Number'**
  String get mpesaNumber;

  /// No description provided for @opay.
  ///
  /// In en, this message translates to:
  /// **'OPay'**
  String get opay;

  /// No description provided for @opayNumber.
  ///
  /// In en, this message translates to:
  /// **'OPay Number'**
  String get opayNumber;

  /// No description provided for @orangeMoney.
  ///
  /// In en, this message translates to:
  /// **'Orange Money'**
  String get orangeMoney;

  /// No description provided for @orangeMoneyNumber.
  ///
  /// In en, this message translates to:
  /// **'Orange Money Number'**
  String get orangeMoneyNumber;

  /// No description provided for @mtnMobile.
  ///
  /// In en, this message translates to:
  /// **'MTN Mobile'**
  String get mtnMobile;

  /// No description provided for @mtnMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'MTN Mobile Number'**
  String get mtnMobileNumber;

  /// No description provided for @chipperCash.
  ///
  /// In en, this message translates to:
  /// **'Chipper Cash'**
  String get chipperCash;

  /// No description provided for @chipperTag.
  ///
  /// In en, this message translates to:
  /// **'Chipper Tag'**
  String get chipperTag;

  /// No description provided for @moniepoint.
  ///
  /// In en, this message translates to:
  /// **'Moniepoint'**
  String get moniepoint;

  /// No description provided for @baxi.
  ///
  /// In en, this message translates to:
  /// **'Baxi'**
  String get baxi;

  /// No description provided for @baxiAccount.
  ///
  /// In en, this message translates to:
  /// **'Baxi Account'**
  String get baxiAccount;

  /// No description provided for @capitecPay.
  ///
  /// In en, this message translates to:
  /// **'Capitec Pay'**
  String get capitecPay;

  /// No description provided for @idPhone.
  ///
  /// In en, this message translates to:
  /// **'ID / Phone'**
  String get idPhone;

  /// No description provided for @snapscan.
  ///
  /// In en, this message translates to:
  /// **'SnapScan'**
  String get snapscan;

  /// No description provided for @snapscanId.
  ///
  /// In en, this message translates to:
  /// **'SnapScan ID'**
  String get snapscanId;

  /// No description provided for @natsWallet.
  ///
  /// In en, this message translates to:
  /// **'NatsWallet'**
  String get natsWallet;

  /// No description provided for @cardAccount.
  ///
  /// In en, this message translates to:
  /// **'Card/Account'**
  String get cardAccount;

  /// No description provided for @onafriq.
  ///
  /// In en, this message translates to:
  /// **'Onafriq'**
  String get onafriq;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// No description provided for @stcPay.
  ///
  /// In en, this message translates to:
  /// **'STC Pay'**
  String get stcPay;

  /// No description provided for @stcPayNumber.
  ///
  /// In en, this message translates to:
  /// **'STC Pay Number'**
  String get stcPayNumber;

  /// No description provided for @vodafoneCash.
  ///
  /// In en, this message translates to:
  /// **'Vodafone Cash'**
  String get vodafoneCash;

  /// No description provided for @vodafoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Vodafone Number'**
  String get vodafoneNumber;

  /// No description provided for @careemPay.
  ///
  /// In en, this message translates to:
  /// **'Careem Pay'**
  String get careemPay;

  /// No description provided for @careemNumber.
  ///
  /// In en, this message translates to:
  /// **'Careem Number'**
  String get careemNumber;

  /// No description provided for @instapay.
  ///
  /// In en, this message translates to:
  /// **'InstaPay'**
  String get instapay;

  /// No description provided for @instapayAddress.
  ///
  /// In en, this message translates to:
  /// **'InstaPay Address'**
  String get instapayAddress;

  /// No description provided for @myfawry.
  ///
  /// In en, this message translates to:
  /// **'myfawry'**
  String get myfawry;

  /// No description provided for @fawryNumber.
  ///
  /// In en, this message translates to:
  /// **'Fawry Number'**
  String get fawryNumber;

  /// No description provided for @benefitPay.
  ///
  /// In en, this message translates to:
  /// **'BenefitPay'**
  String get benefitPay;

  /// No description provided for @benefitpayNumber.
  ///
  /// In en, this message translates to:
  /// **'BenefitPay Number'**
  String get benefitpayNumber;

  /// No description provided for @meeza.
  ///
  /// In en, this message translates to:
  /// **'Meeza'**
  String get meeza;

  /// No description provided for @meezaCardWallet.
  ///
  /// In en, this message translates to:
  /// **'Meeza Card/Wallet'**
  String get meezaCardWallet;

  /// No description provided for @valu.
  ///
  /// In en, this message translates to:
  /// **'valU'**
  String get valu;

  /// No description provided for @valuAccount.
  ///
  /// In en, this message translates to:
  /// **'valU Account'**
  String get valuAccount;

  /// No description provided for @nubank.
  ///
  /// In en, this message translates to:
  /// **'Nubank'**
  String get nubank;

  /// No description provided for @pixpayAccount.
  ///
  /// In en, this message translates to:
  /// **'Pix Key / Account'**
  String get pixpayAccount;

  /// No description provided for @picpay.
  ///
  /// In en, this message translates to:
  /// **'PicPay'**
  String get picpay;

  /// No description provided for @picpayUsernamePix.
  ///
  /// In en, this message translates to:
  /// **'PicPay Username / Pix'**
  String get picpayUsernamePix;

  /// No description provided for @mercadoPago.
  ///
  /// In en, this message translates to:
  /// **'Mercado Pago'**
  String get mercadoPago;

  /// No description provided for @emailCvu.
  ///
  /// In en, this message translates to:
  /// **'Email / CVU'**
  String get emailCvu;

  /// No description provided for @nequi.
  ///
  /// In en, this message translates to:
  /// **'Nequi'**
  String get nequi;

  /// No description provided for @nequiNumber.
  ///
  /// In en, this message translates to:
  /// **'Nequi Number'**
  String get nequiNumber;

  /// No description provided for @daviplata.
  ///
  /// In en, this message translates to:
  /// **'Daviplata'**
  String get daviplata;

  /// No description provided for @daviplataNumber.
  ///
  /// In en, this message translates to:
  /// **'Daviplata Number'**
  String get daviplataNumber;

  /// No description provided for @yape.
  ///
  /// In en, this message translates to:
  /// **'Yape'**
  String get yape;

  /// No description provided for @yapeNumber.
  ///
  /// In en, this message translates to:
  /// **'Yape Number'**
  String get yapeNumber;

  /// No description provided for @plin.
  ///
  /// In en, this message translates to:
  /// **'Plin'**
  String get plin;

  /// No description provided for @plinNumber.
  ///
  /// In en, this message translates to:
  /// **'Plin Number'**
  String get plinNumber;

  /// No description provided for @rappiPay.
  ///
  /// In en, this message translates to:
  /// **'RappiPay'**
  String get rappiPay;

  /// No description provided for @rappiAccount.
  ///
  /// In en, this message translates to:
  /// **'Rappi Account'**
  String get rappiAccount;

  /// No description provided for @mach.
  ///
  /// In en, this message translates to:
  /// **'MACH'**
  String get mach;

  /// No description provided for @machAccount.
  ///
  /// In en, this message translates to:
  /// **'MACH Account'**
  String get machAccount;

  /// No description provided for @prex.
  ///
  /// In en, this message translates to:
  /// **'Prex'**
  String get prex;

  /// No description provided for @prexAccount.
  ///
  /// In en, this message translates to:
  /// **'Prex Account'**
  String get prexAccount;

  /// No description provided for @payId.
  ///
  /// In en, this message translates to:
  /// **'PayID'**
  String get payId;

  /// No description provided for @payIdEmail.
  ///
  /// In en, this message translates to:
  /// **'PayID (Email/Phone)'**
  String get payIdEmail;

  /// No description provided for @commbank.
  ///
  /// In en, this message translates to:
  /// **'CommBank'**
  String get commbank;

  /// No description provided for @bsbAccount.
  ///
  /// In en, this message translates to:
  /// **'BSB & Account'**
  String get bsbAccount;

  /// No description provided for @westpac.
  ///
  /// In en, this message translates to:
  /// **'Westpac'**
  String get westpac;

  /// No description provided for @anz.
  ///
  /// In en, this message translates to:
  /// **'ANZ'**
  String get anz;

  /// No description provided for @nab.
  ///
  /// In en, this message translates to:
  /// **'NAB'**
  String get nab;

  /// No description provided for @up.
  ///
  /// In en, this message translates to:
  /// **'Up'**
  String get up;

  /// No description provided for @upnamePayId.
  ///
  /// In en, this message translates to:
  /// **'Upname / PayID'**
  String get upnamePayId;

  /// No description provided for @afterpay.
  ///
  /// In en, this message translates to:
  /// **'Afterpay'**
  String get afterpay;

  /// No description provided for @accountEmail.
  ///
  /// In en, this message translates to:
  /// **'Account Email'**
  String get accountEmail;

  /// No description provided for @zip.
  ///
  /// In en, this message translates to:
  /// **'Zip'**
  String get zip;

  /// No description provided for @zipId.
  ///
  /// In en, this message translates to:
  /// **'Zip ID'**
  String get zipId;

  /// No description provided for @kiwibank.
  ///
  /// In en, this message translates to:
  /// **'Kiwibank'**
  String get kiwibank;

  /// No description provided for @scotiabank.
  ///
  /// In en, this message translates to:
  /// **'Scotiabank'**
  String get scotiabank;

  /// No description provided for @baseIdAccount.
  ///
  /// In en, this message translates to:
  /// **'Base ID / Account'**
  String get baseIdAccount;

  /// No description provided for @bitcoin.
  ///
  /// In en, this message translates to:
  /// **'Bitcoin'**
  String get bitcoin;

  /// No description provided for @btcWalletAddress.
  ///
  /// In en, this message translates to:
  /// **'BTC Wallet Address'**
  String get btcWalletAddress;

  /// No description provided for @ethereum.
  ///
  /// In en, this message translates to:
  /// **'Ethereum'**
  String get ethereum;

  /// No description provided for @ethWalletAddress.
  ///
  /// In en, this message translates to:
  /// **'ETH Wallet Address'**
  String get ethWalletAddress;

  /// No description provided for @usdt.
  ///
  /// In en, this message translates to:
  /// **'USDT'**
  String get usdt;

  /// No description provided for @usdtNetwork.
  ///
  /// In en, this message translates to:
  /// **'TRC20 / BEP20'**
  String get usdtNetwork;

  /// No description provided for @usdc.
  ///
  /// In en, this message translates to:
  /// **'USDC'**
  String get usdc;

  /// No description provided for @usdcNetwork.
  ///
  /// In en, this message translates to:
  /// **'ERC20 / SPL Address'**
  String get usdcNetwork;

  /// No description provided for @binancePay.
  ///
  /// In en, this message translates to:
  /// **'Binance Pay'**
  String get binancePay;

  /// No description provided for @binanceIdEmail.
  ///
  /// In en, this message translates to:
  /// **'Binance ID / Email'**
  String get binanceIdEmail;

  /// No description provided for @bnb.
  ///
  /// In en, this message translates to:
  /// **'BNB'**
  String get bnb;

  /// No description provided for @bep20Address.
  ///
  /// In en, this message translates to:
  /// **'BEP20 Address'**
  String get bep20Address;

  /// No description provided for @litecoin.
  ///
  /// In en, this message translates to:
  /// **'Litecoin'**
  String get litecoin;

  /// No description provided for @ltcWalletAddress.
  ///
  /// In en, this message translates to:
  /// **'LTC Wallet Address'**
  String get ltcWalletAddress;

  /// No description provided for @tron.
  ///
  /// In en, this message translates to:
  /// **'Tron (TRX)'**
  String get tron;

  /// No description provided for @trxAddress.
  ///
  /// In en, this message translates to:
  /// **'TRX Address'**
  String get trxAddress;

  /// No description provided for @dogecoin.
  ///
  /// In en, this message translates to:
  /// **'Dogecoin'**
  String get dogecoin;

  /// No description provided for @dogeAddress.
  ///
  /// In en, this message translates to:
  /// **'DOGE Address'**
  String get dogeAddress;

  /// No description provided for @shibaInu.
  ///
  /// In en, this message translates to:
  /// **'Shiba Inu'**
  String get shibaInu;

  /// No description provided for @shibAddress.
  ///
  /// In en, this message translates to:
  /// **'SHIB (BEP20) Address'**
  String get shibAddress;

  /// No description provided for @solana.
  ///
  /// In en, this message translates to:
  /// **'Solana'**
  String get solana;

  /// No description provided for @solAddress.
  ///
  /// In en, this message translates to:
  /// **'SOL Address'**
  String get solAddress;

  /// No description provided for @ripple.
  ///
  /// In en, this message translates to:
  /// **'Ripple (XRP)'**
  String get ripple;

  /// No description provided for @xrpAddressTag.
  ///
  /// In en, this message translates to:
  /// **'XRP Address & Tag'**
  String get xrpAddressTag;

  /// No description provided for @polygon.
  ///
  /// In en, this message translates to:
  /// **'Polygon (MATIC)'**
  String get polygon;

  /// No description provided for @polygonAddress.
  ///
  /// In en, this message translates to:
  /// **'Polygon Address'**
  String get polygonAddress;

  /// No description provided for @dash.
  ///
  /// In en, this message translates to:
  /// **'Dash'**
  String get dash;

  /// No description provided for @dashAddress.
  ///
  /// In en, this message translates to:
  /// **'Dash Address'**
  String get dashAddress;

  /// No description provided for @bitcoinCash.
  ///
  /// In en, this message translates to:
  /// **'Bitcoin Cash'**
  String get bitcoinCash;

  /// No description provided for @bchAddress.
  ///
  /// In en, this message translates to:
  /// **'BCH Address'**
  String get bchAddress;

  /// No description provided for @perfectMoney.
  ///
  /// In en, this message translates to:
  /// **'Perfect Money'**
  String get perfectMoney;

  /// No description provided for @perfectMoneyAccount.
  ///
  /// In en, this message translates to:
  /// **'Perfect Money Account (U...)'**
  String get perfectMoneyAccount;

  /// No description provided for @googlePlay.
  ///
  /// In en, this message translates to:
  /// **'Google Play'**
  String get googlePlay;

  /// No description provided for @emailToSendCode.
  ///
  /// In en, this message translates to:
  /// **'Email to send code'**
  String get emailToSendCode;

  /// No description provided for @appleGiftCard.
  ///
  /// In en, this message translates to:
  /// **'Apple Gift Card'**
  String get appleGiftCard;

  /// No description provided for @steamWallet.
  ///
  /// In en, this message translates to:
  /// **'Steam Wallet'**
  String get steamWallet;

  /// No description provided for @playstation.
  ///
  /// In en, this message translates to:
  /// **'PlayStation'**
  String get playstation;

  /// No description provided for @xboxLive.
  ///
  /// In en, this message translates to:
  /// **'Xbox Live'**
  String get xboxLive;

  /// No description provided for @nintendoEshop.
  ///
  /// In en, this message translates to:
  /// **'Nintendo eShop'**
  String get nintendoEshop;

  /// No description provided for @razerGold.
  ///
  /// In en, this message translates to:
  /// **'Razer Gold'**
  String get razerGold;

  /// No description provided for @razerIdEmail.
  ///
  /// In en, this message translates to:
  /// **'Razer ID / Email'**
  String get razerIdEmail;

  /// No description provided for @amazon.
  ///
  /// In en, this message translates to:
  /// **'Amazon'**
  String get amazon;

  /// No description provided for @ebay.
  ///
  /// In en, this message translates to:
  /// **'eBay'**
  String get ebay;

  /// No description provided for @walmart.
  ///
  /// In en, this message translates to:
  /// **'Walmart'**
  String get walmart;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @shien.
  ///
  /// In en, this message translates to:
  /// **'Shien'**
  String get shien;

  /// No description provided for @sephora.
  ///
  /// In en, this message translates to:
  /// **'Sephora'**
  String get sephora;

  /// No description provided for @nike.
  ///
  /// In en, this message translates to:
  /// **'Nike'**
  String get nike;

  /// No description provided for @netflix.
  ///
  /// In en, this message translates to:
  /// **'Netflix'**
  String get netflix;

  /// No description provided for @spotify.
  ///
  /// In en, this message translates to:
  /// **'Spotify'**
  String get spotify;

  /// No description provided for @disneyPlus.
  ///
  /// In en, this message translates to:
  /// **'Disney+'**
  String get disneyPlus;

  /// No description provided for @twitch.
  ///
  /// In en, this message translates to:
  /// **'Twitch'**
  String get twitch;

  /// No description provided for @starbucks.
  ///
  /// In en, this message translates to:
  /// **'Starbucks'**
  String get starbucks;

  /// No description provided for @uberEats.
  ///
  /// In en, this message translates to:
  /// **'Uber / Eats'**
  String get uberEats;

  /// No description provided for @doordash.
  ///
  /// In en, this message translates to:
  /// **'DoorDash'**
  String get doordash;

  /// No description provided for @visaPrepaid.
  ///
  /// In en, this message translates to:
  /// **'Visa Prepaid'**
  String get visaPrepaid;

  /// No description provided for @mastercard.
  ///
  /// In en, this message translates to:
  /// **'Mastercard'**
  String get mastercard;

  /// No description provided for @freeFire.
  ///
  /// In en, this message translates to:
  /// **'Free Fire'**
  String get freeFire;

  /// No description provided for @playerIdUid.
  ///
  /// In en, this message translates to:
  /// **'Player ID (UID)'**
  String get playerIdUid;

  /// No description provided for @pubgMobile.
  ///
  /// In en, this message translates to:
  /// **'PUBG Mobile'**
  String get pubgMobile;

  /// No description provided for @characterId.
  ///
  /// In en, this message translates to:
  /// **'Character ID'**
  String get characterId;

  /// No description provided for @codMobile.
  ///
  /// In en, this message translates to:
  /// **'CoD Mobile'**
  String get codMobile;

  /// No description provided for @fortnite.
  ///
  /// In en, this message translates to:
  /// **'Fortnite'**
  String get fortnite;

  /// No description provided for @epicGamesUsername.
  ///
  /// In en, this message translates to:
  /// **'Epic Games Username'**
  String get epicGamesUsername;

  /// No description provided for @apexLegends.
  ///
  /// In en, this message translates to:
  /// **'Apex Legends'**
  String get apexLegends;

  /// No description provided for @eaIdUsername.
  ///
  /// In en, this message translates to:
  /// **'EA ID / Username'**
  String get eaIdUsername;

  /// No description provided for @mobileLegends.
  ///
  /// In en, this message translates to:
  /// **'Mobile Legends'**
  String get mobileLegends;

  /// No description provided for @userIdZoneId.
  ///
  /// In en, this message translates to:
  /// **'User ID & Zone ID'**
  String get userIdZoneId;

  /// No description provided for @leagueOfLegends.
  ///
  /// In en, this message translates to:
  /// **'League of Legends'**
  String get leagueOfLegends;

  /// No description provided for @riotIdNameTag.
  ///
  /// In en, this message translates to:
  /// **'Riot ID (Name#Tag)'**
  String get riotIdNameTag;

  /// No description provided for @brawlStars.
  ///
  /// In en, this message translates to:
  /// **'Brawl Stars'**
  String get brawlStars;

  /// No description provided for @playerTag.
  ///
  /// In en, this message translates to:
  /// **'Player Tag (#...)'**
  String get playerTag;

  /// No description provided for @valorant.
  ///
  /// In en, this message translates to:
  /// **'Valorant'**
  String get valorant;

  /// No description provided for @genshinImpact.
  ///
  /// In en, this message translates to:
  /// **'Genshin Impact'**
  String get genshinImpact;

  /// No description provided for @userIdServer.
  ///
  /// In en, this message translates to:
  /// **'User ID & Server'**
  String get userIdServer;

  /// No description provided for @robux.
  ///
  /// In en, this message translates to:
  /// **'Robux'**
  String get robux;

  /// No description provided for @robloxUsername.
  ///
  /// In en, this message translates to:
  /// **'Roblox Username'**
  String get robloxUsername;

  /// No description provided for @minecraft.
  ///
  /// In en, this message translates to:
  /// **'Minecraft'**
  String get minecraft;

  /// No description provided for @xboxGamertagEmail.
  ///
  /// In en, this message translates to:
  /// **'Xbox Gamertag / Email'**
  String get xboxGamertagEmail;

  /// No description provided for @clashOfClans.
  ///
  /// In en, this message translates to:
  /// **'Clash of Clans'**
  String get clashOfClans;

  /// No description provided for @eaFc.
  ///
  /// In en, this message translates to:
  /// **'EA FC'**
  String get eaFc;

  /// No description provided for @eaIdPsnXbox.
  ///
  /// In en, this message translates to:
  /// **'EA ID / PSN / Xbox'**
  String get eaIdPsnXbox;

  /// No description provided for @pleaseSelectWithdrawSubType.
  ///
  /// In en, this message translates to:
  /// **'Please select withdraw sub type'**
  String get pleaseSelectWithdrawSubType;

  /// No description provided for @pleaseSelectWithdrawType.
  ///
  /// In en, this message translates to:
  /// **'Please select withdraw type'**
  String get pleaseSelectWithdrawType;

  /// No description provided for @pleaseEnterWalletAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter wallet address'**
  String get pleaseEnterWalletAddress;

  /// No description provided for @pleaseEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid amount'**
  String get pleaseEnterValidAmount;

  /// No description provided for @minimumWithdrawIs.
  ///
  /// In en, this message translates to:
  /// **'Minimum withdrawal is '**
  String get minimumWithdrawIs;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value: '**
  String get value;

  /// No description provided for @amountCoins.
  ///
  /// In en, this message translates to:
  /// **'Amount (Coins)'**
  String get amountCoins;

  /// No description provided for @additionalNote.
  ///
  /// In en, this message translates to:
  /// **'Additional Note (Optional)'**
  String get additionalNote;

  /// No description provided for @withdrawRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Withdraw request sent'**
  String get withdrawRequestSent;

  /// No description provided for @confirmWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM WITHDRAWAL'**
  String get confirmWithdrawal;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Field required'**
  String get fieldRequired;

  /// No description provided for @invalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get invalidInput;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min: '**
  String get min;

  /// No description provided for @withdrawTo.
  ///
  /// In en, this message translates to:
  /// **'Withdraw to'**
  String get withdrawTo;

  /// No description provided for @withdrawHistory.
  ///
  /// In en, this message translates to:
  /// **'Withdraw History'**
  String get withdrawHistory;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @pleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get pleaseTryAgainLater;

  /// No description provided for @noWithdrawalsYet.
  ///
  /// In en, this message translates to:
  /// **'No withdrawals yet'**
  String get noWithdrawalsYet;

  /// No description provided for @yourWithdrawRequestAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your withdrawal requests will appear here'**
  String get yourWithdrawRequestAppearHere;

  /// No description provided for @method.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get method;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'REJECTED'**
  String get rejected;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'APPROVED'**
  String get approved;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get pending;

  /// No description provided for @processed.
  ///
  /// In en, this message translates to:
  /// **'Processed'**
  String get processed;

  /// No description provided for @twoBusinessDays.
  ///
  /// In en, this message translates to:
  /// **'2 business days'**
  String get twoBusinessDays;

  /// No description provided for @statusNote.
  ///
  /// In en, this message translates to:
  /// **'Status note'**
  String get statusNote;

  /// No description provided for @underReview.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get underReview;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'pt',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
