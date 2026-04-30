import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
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
/// import 'gen/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CardiBee'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Scout. Compare. Save.'**
  String get appTagline;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Card offers, any brand, anytime'**
  String get appSubtitle;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Scout · Compare · Save'**
  String get splashTagline;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get onboardingAlreadyHaveAccount;

  /// No description provided for @onboardingLogin.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get onboardingLogin;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Add your cards'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Body.
  ///
  /// In en, this message translates to:
  /// **'Save the credit & debit cards you carry. We never ask for card numbers — just bank, network and type.'**
  String get onboardingSlide1Body;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'See every offer'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Body.
  ///
  /// In en, this message translates to:
  /// **'Discover discounts, cashback and BOGO deals across food, travel, shopping and more — all matched to your wallet.'**
  String get onboardingSlide2Body;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Never miss a deal'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Body.
  ///
  /// In en, this message translates to:
  /// **'Get alerted when offers are about to expire and always pick the card that gives you the best value.'**
  String get onboardingSlide3Body;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get authCreateAccount;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authWelcomeBack;

  /// No description provided for @authStartSaving.
  ///
  /// In en, this message translates to:
  /// **'Start saving on every swipe'**
  String get authStartSaving;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to see your deals'**
  String get authLoginSubtitle;

  /// No description provided for @authPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get authPhone;

  /// No description provided for @authPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+880 1X XXXX XXXX'**
  String get authPhoneHint;

  /// No description provided for @authName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get authName;

  /// No description provided for @authNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get authNameHint;

  /// No description provided for @authSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get authSendOtp;

  /// No description provided for @authVerifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get authVerifyOtp;

  /// No description provided for @authOtpSentTo.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to {phone}'**
  String authOtpSentTo(String phone);

  /// No description provided for @authEnterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get authEnterOtp;

  /// No description provided for @authResendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get authResendOtp;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authNewToCardibee.
  ///
  /// In en, this message translates to:
  /// **'New to CardiBee?'**
  String get authNewToCardibee;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authSignUp;

  /// No description provided for @authCreateBtn.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateBtn;

  /// No description provided for @authLoginBtn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get authLoginBtn;

  /// No description provided for @authSecurityNote.
  ///
  /// In en, this message translates to:
  /// **'🔒 We never share your data or ask for card credentials.'**
  String get authSecurityNote;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, welcome back'**
  String get homeGreeting;

  /// No description provided for @homeHi.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name} 👋'**
  String homeHi(String name);

  /// No description provided for @homeSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search merchants, banks or offers'**
  String get homeSearchPlaceholder;

  /// No description provided for @homeWalletLabel.
  ///
  /// In en, this message translates to:
  /// **'Your wallet'**
  String get homeWalletLabel;

  /// No description provided for @homeCardsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cards'**
  String homeCardsCount(int count);

  /// No description provided for @homeActiveOffersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} offers active for you'**
  String homeActiveOffersCount(int count);

  /// No description provided for @homeViewCards.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get homeViewCards;

  /// No description provided for @homeBrowseByCategory.
  ///
  /// In en, this message translates to:
  /// **'Browse by category'**
  String get homeBrowseByCategory;

  /// No description provided for @homeFeaturedOffers.
  ///
  /// In en, this message translates to:
  /// **'Featured offers ✨'**
  String get homeFeaturedOffers;

  /// No description provided for @homeExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get homeExpiringSoon;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @myOffersTitle.
  ///
  /// In en, this message translates to:
  /// **'My offers'**
  String get myOffersTitle;

  /// No description provided for @myOffersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} deals matched to your cards'**
  String myOffersSubtitle(int count);

  /// No description provided for @myOffersEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add a card to begin'**
  String get myOffersEmpty;

  /// No description provided for @myOffersEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Once you add cards, we\'ll surface every offer that matches your wallet.'**
  String get myOffersEmptyBody;

  /// No description provided for @myOffersAddCard.
  ///
  /// In en, this message translates to:
  /// **'Add card'**
  String get myOffersAddCard;

  /// No description provided for @myOffersFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get myOffersFilterAll;

  /// No description provided for @myOffersResults.
  ///
  /// In en, this message translates to:
  /// **'{count} results'**
  String myOffersResults(int count);

  /// No description provided for @myOffersSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get myOffersSort;

  /// No description provided for @myOffersSortExpiring.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get myOffersSortExpiring;

  /// No description provided for @myOffersSortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get myOffersSortNewest;

  /// No description provided for @myOffersSortHighest.
  ///
  /// In en, this message translates to:
  /// **'Highest discount'**
  String get myOffersSortHighest;

  /// No description provided for @browseTitle.
  ///
  /// In en, this message translates to:
  /// **'Browse all offers'**
  String get browseTitle;

  /// No description provided for @browseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover every deal in the catalog'**
  String get browseSubtitle;

  /// No description provided for @browseSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search merchants or categories'**
  String get browseSearchPlaceholder;

  /// No description provided for @browseNoResults.
  ///
  /// In en, this message translates to:
  /// **'No offers match your search.'**
  String get browseNoResults;

  /// No description provided for @offerDetailValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until'**
  String get offerDetailValidUntil;

  /// No description provided for @offerDetailMinSpend.
  ///
  /// In en, this message translates to:
  /// **'Min spend'**
  String get offerDetailMinSpend;

  /// No description provided for @offerDetailMaxOff.
  ///
  /// In en, this message translates to:
  /// **'Max off'**
  String get offerDetailMaxOff;

  /// No description provided for @offerDetailNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get offerDetailNone;

  /// No description provided for @offerDetailApplicableOn.
  ///
  /// In en, this message translates to:
  /// **'Applicable on'**
  String get offerDetailApplicableOn;

  /// No description provided for @offerDetailYourCardsQualify.
  ///
  /// In en, this message translates to:
  /// **'{count} of your cards qualify'**
  String offerDetailYourCardsQualify(int count);

  /// No description provided for @offerDetailYourCard.
  ///
  /// In en, this message translates to:
  /// **'YOUR CARD'**
  String get offerDetailYourCard;

  /// No description provided for @offerDetailAbout.
  ///
  /// In en, this message translates to:
  /// **'About this offer'**
  String get offerDetailAbout;

  /// No description provided for @offerDetailTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms & conditions'**
  String get offerDetailTerms;

  /// No description provided for @offerDetailSecurityNote.
  ///
  /// In en, this message translates to:
  /// **'🔒 CardiBee never processes payments or connects to your bank. Apply this offer at the merchant using your card.'**
  String get offerDetailSecurityNote;

  /// No description provided for @offerDetailVisitMerchant.
  ///
  /// In en, this message translates to:
  /// **'Visit merchant'**
  String get offerDetailVisitMerchant;

  /// No description provided for @offerDetailShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get offerDetailShare;

  /// No description provided for @cardsTitle.
  ///
  /// In en, this message translates to:
  /// **'My cards'**
  String get cardsTitle;

  /// No description provided for @cardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} cards saved · No card numbers stored'**
  String cardsSubtitle(int count);

  /// No description provided for @cardsActiveOffers.
  ///
  /// In en, this message translates to:
  /// **'{count} active offers'**
  String cardsActiveOffers(int count);

  /// No description provided for @cardsTapToView.
  ///
  /// In en, this message translates to:
  /// **'Tap card to view'**
  String get cardsTapToView;

  /// No description provided for @cardsAddCard.
  ///
  /// In en, this message translates to:
  /// **'Add card'**
  String get cardsAddCard;

  /// No description provided for @cardsDeleteCard.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get cardsDeleteCard;

  /// No description provided for @addCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new card'**
  String get addCardTitle;

  /// No description provided for @addCardStep.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String addCardStep(int current, int total);

  /// No description provided for @addCardChooseBank.
  ///
  /// In en, this message translates to:
  /// **'Choose your bank'**
  String get addCardChooseBank;

  /// No description provided for @addCardPickProduct.
  ///
  /// In en, this message translates to:
  /// **'Pick your card product'**
  String get addCardPickProduct;

  /// No description provided for @addCardDetails.
  ///
  /// In en, this message translates to:
  /// **'Card details'**
  String get addCardDetails;

  /// No description provided for @addCardNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get addCardNetwork;

  /// No description provided for @addCardType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get addCardType;

  /// No description provided for @addCardNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname (optional)'**
  String get addCardNickname;

  /// No description provided for @addCardNicknameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Daily Driver'**
  String get addCardNicknameHint;

  /// No description provided for @addCardLast4.
  ///
  /// In en, this message translates to:
  /// **'Last 4 digits (optional)'**
  String get addCardLast4;

  /// No description provided for @addCardLast4Hint.
  ///
  /// In en, this message translates to:
  /// **'0000'**
  String get addCardLast4Hint;

  /// No description provided for @addCardSecurityNote.
  ///
  /// In en, this message translates to:
  /// **'🔒 We never ask for full card numbers, CVV or PIN.'**
  String get addCardSecurityNote;

  /// No description provided for @addCardContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get addCardContinue;

  /// No description provided for @addCardPickStyle.
  ///
  /// In en, this message translates to:
  /// **'Pick a style'**
  String get addCardPickStyle;

  /// No description provided for @addCardSave.
  ///
  /// In en, this message translates to:
  /// **'Save card'**
  String get addCardSave;

  /// No description provided for @addCardCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get addCardCredit;

  /// No description provided for @addCardDebit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get addCardDebit;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @favoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} saved offers'**
  String favoritesSubtitle(int count);

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet — tap the heart on any offer to save it.'**
  String get favoritesEmpty;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get profileCards;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get profileSaved;

  /// No description provided for @profileSavingsYtd.
  ///
  /// In en, this message translates to:
  /// **'Saved YTD'**
  String get profileSavingsYtd;

  /// No description provided for @profileDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get profileDarkMode;

  /// No description provided for @profileLightMode.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get profileLightMode;

  /// No description provided for @profileOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get profileOn;

  /// No description provided for @profileOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get profileOff;

  /// No description provided for @profileMyCards.
  ///
  /// In en, this message translates to:
  /// **'My cards'**
  String get profileMyCards;

  /// No description provided for @profileFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get profileFavorites;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy & security'**
  String get profilePrivacy;

  /// No description provided for @profileTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get profileTerms;

  /// No description provided for @profileAbout.
  ///
  /// In en, this message translates to:
  /// **'About CardiBee'**
  String get profileAbout;

  /// No description provided for @profileLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogOut;

  /// No description provided for @profileVersion.
  ///
  /// In en, this message translates to:
  /// **'CardiBee v1.0 · Made in 🇧🇩'**
  String get profileVersion;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up!'**
  String get notificationsEmpty;

  /// No description provided for @subscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get subscriptionTitle;

  /// No description provided for @subscriptionFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get subscriptionFree;

  /// No description provided for @subscriptionPro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get subscriptionPro;

  /// No description provided for @subscriptionMonthly.
  ///
  /// In en, this message translates to:
  /// **'৳{price}/month'**
  String subscriptionMonthly(int price);

  /// No description provided for @subscriptionAnnual.
  ///
  /// In en, this message translates to:
  /// **'৳{price}/year'**
  String subscriptionAnnual(int price);

  /// No description provided for @subscriptionCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current plan'**
  String get subscriptionCurrentPlan;

  /// No description provided for @subscriptionUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade now'**
  String get subscriptionUpgrade;

  /// No description provided for @subscriptionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel subscription'**
  String get subscriptionCancel;

  /// No description provided for @bestCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Best card for this'**
  String get bestCardTitle;

  /// No description provided for @bestCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Based on your registered cards'**
  String get bestCardSubtitle;

  /// No description provided for @bestCardSaving.
  ///
  /// In en, this message translates to:
  /// **'You could save'**
  String get bestCardSaving;

  /// No description provided for @bestCardNoCards.
  ///
  /// In en, this message translates to:
  /// **'Add cards to get a suggestion'**
  String get bestCardNoCards;

  /// No description provided for @compareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare cards'**
  String get compareTitle;

  /// No description provided for @compareSelect.
  ///
  /// In en, this message translates to:
  /// **'Select cards to compare'**
  String get compareSelect;

  /// No description provided for @comparePotentialSavings.
  ///
  /// In en, this message translates to:
  /// **'Potential savings'**
  String get comparePotentialSavings;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out.'**
  String get errorTimeout;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please log in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our end.'**
  String get errorServer;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get errorGeneric;

  /// No description provided for @errorCardLimit.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro to add more cards.'**
  String get errorCardLimit;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get categoryFood;

  /// No description provided for @categoryTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get categoryTravel;

  /// No description provided for @categoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryGroceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get categoryGroceries;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count}d left'**
  String daysLeft(int count);

  /// No description provided for @untilDate.
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String untilDate(String date);

  /// No description provided for @amountBdt.
  ///
  /// In en, this message translates to:
  /// **'৳{amount}'**
  String amountBdt(String amount);
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
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
