// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CardiBee';

  @override
  String get appTagline => 'Scout. Compare. Save.';

  @override
  String get appSubtitle => 'Card offers, any brand, anytime';

  @override
  String get splashTagline => 'Scout · Compare · Save';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingAlreadyHaveAccount => 'Already have an account?';

  @override
  String get onboardingLogin => 'Log in';

  @override
  String get onboardingSlide1Title => 'Add your cards';

  @override
  String get onboardingSlide1Body =>
      'Save the credit & debit cards you carry. We never ask for card numbers — just bank, network and type.';

  @override
  String get onboardingSlide2Title => 'See every offer';

  @override
  String get onboardingSlide2Body =>
      'Discover discounts, cashback and BOGO deals across food, travel, shopping and more — all matched to your wallet.';

  @override
  String get onboardingSlide3Title => 'Never miss a deal';

  @override
  String get onboardingSlide3Body =>
      'Get alerted when offers are about to expire and always pick the card that gives you the best value.';

  @override
  String get authCreateAccount => 'Create your account';

  @override
  String get authWelcomeBack => 'Welcome back';

  @override
  String get authStartSaving => 'Start saving on every swipe';

  @override
  String get authLoginSubtitle => 'Log in to see your deals';

  @override
  String get authPhone => 'Phone number';

  @override
  String get authPhoneHint => '+880 1X XXXX XXXX';

  @override
  String get authName => 'Full name';

  @override
  String get authNameHint => 'Your full name';

  @override
  String get authSendOtp => 'Send OTP';

  @override
  String get authVerifyOtp => 'Verify OTP';

  @override
  String authOtpSentTo(String phone) {
    return 'OTP sent to $phone';
  }

  @override
  String get authEnterOtp => 'Enter the 6-digit code';

  @override
  String get authResendOtp => 'Resend OTP';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authNewToCardibee => 'New to CardiBee?';

  @override
  String get authSignUp => 'Sign up';

  @override
  String get authCreateBtn => 'Create account';

  @override
  String get authLoginBtn => 'Log in';

  @override
  String get authSecurityNote =>
      '🔒 We never share your data or ask for card credentials.';

  @override
  String get homeGreeting => 'Hello, welcome back';

  @override
  String homeHi(String name) {
    return 'Hi, $name 👋';
  }

  @override
  String get homeSearchPlaceholder => 'Search merchants, banks or offers';

  @override
  String get homeWalletLabel => 'Your wallet';

  @override
  String homeCardsCount(int count) {
    return '$count cards';
  }

  @override
  String homeActiveOffersCount(int count) {
    return '$count offers active for you';
  }

  @override
  String get homeViewCards => 'View';

  @override
  String get homeBrowseByCategory => 'Browse by category';

  @override
  String get homeFeaturedOffers => 'Featured offers ✨';

  @override
  String get homeExpiringSoon => 'Expiring soon';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get myOffersTitle => 'My offers';

  @override
  String myOffersSubtitle(int count) {
    return '$count deals matched to your cards';
  }

  @override
  String get myOffersEmpty => 'Add a card to begin';

  @override
  String get myOffersEmptyBody =>
      'Once you add cards, we\'ll surface every offer that matches your wallet.';

  @override
  String get myOffersAddCard => 'Add card';

  @override
  String get myOffersFilterAll => 'All';

  @override
  String myOffersResults(int count) {
    return '$count results';
  }

  @override
  String get myOffersSort => 'Sort';

  @override
  String get myOffersSortExpiring => 'Expiring soon';

  @override
  String get myOffersSortNewest => 'Newest';

  @override
  String get myOffersSortHighest => 'Highest discount';

  @override
  String get browseTitle => 'Browse all offers';

  @override
  String get browseSubtitle => 'Discover every deal in the catalog';

  @override
  String get browseSearchPlaceholder => 'Search merchants or categories';

  @override
  String get browseNoResults => 'No offers match your search.';

  @override
  String get offerDetailValidUntil => 'Valid until';

  @override
  String get offerDetailMinSpend => 'Min spend';

  @override
  String get offerDetailMaxOff => 'Max off';

  @override
  String get offerDetailNone => 'None';

  @override
  String get offerDetailApplicableOn => 'Applicable on';

  @override
  String offerDetailYourCardsQualify(int count) {
    return '$count of your cards qualify';
  }

  @override
  String get offerDetailYourCard => 'YOUR CARD';

  @override
  String get offerDetailAbout => 'About this offer';

  @override
  String get offerDetailTerms => 'Terms & conditions';

  @override
  String get offerDetailSecurityNote =>
      '🔒 CardiBee never processes payments or connects to your bank. Apply this offer at the merchant using your card.';

  @override
  String get offerDetailVisitMerchant => 'Visit merchant';

  @override
  String get offerDetailShare => 'Share';

  @override
  String get cardsTitle => 'My cards';

  @override
  String cardsSubtitle(int count) {
    return '$count cards saved · No card numbers stored';
  }

  @override
  String cardsActiveOffers(int count) {
    return '$count active offers';
  }

  @override
  String get cardsTapToView => 'Tap card to view';

  @override
  String get cardsAddCard => 'Add card';

  @override
  String get cardsDeleteCard => 'Delete';

  @override
  String get addCardTitle => 'Add a new card';

  @override
  String addCardStep(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get addCardChooseBank => 'Choose your bank';

  @override
  String get addCardPickProduct => 'Pick your card product';

  @override
  String get addCardDetails => 'Card details';

  @override
  String get addCardNetwork => 'Network';

  @override
  String get addCardType => 'Type';

  @override
  String get addCardNickname => 'Nickname (optional)';

  @override
  String get addCardNicknameHint => 'e.g. Daily Driver';

  @override
  String get addCardLast4 => 'Last 4 digits (optional)';

  @override
  String get addCardLast4Hint => '0000';

  @override
  String get addCardSecurityNote =>
      '🔒 We never ask for full card numbers, CVV or PIN.';

  @override
  String get addCardContinue => 'Continue';

  @override
  String get addCardPickStyle => 'Pick a style';

  @override
  String get addCardSave => 'Save card';

  @override
  String get addCardCredit => 'Credit';

  @override
  String get addCardDebit => 'Debit';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String favoritesSubtitle(int count) {
    return '$count saved offers';
  }

  @override
  String get favoritesEmpty =>
      'No favorites yet — tap the heart on any offer to save it.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileCards => 'Cards';

  @override
  String get profileSaved => 'Saved';

  @override
  String get profileSavingsYtd => 'Saved YTD';

  @override
  String get profileDarkMode => 'Dark mode';

  @override
  String get profileLightMode => 'Light mode';

  @override
  String get profileOn => 'On';

  @override
  String get profileOff => 'Off';

  @override
  String get profileMyCards => 'My cards';

  @override
  String get profileFavorites => 'Favorites';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profilePrivacy => 'Privacy & security';

  @override
  String get profileTerms => 'Terms of service';

  @override
  String get profileAbout => 'About CardiBee';

  @override
  String get profileLogOut => 'Log out';

  @override
  String get profileVersion => 'CardiBee v1.0 · Made in 🇧🇩';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String get notificationsEmpty => 'You\'re all caught up!';

  @override
  String get subscriptionTitle => 'Upgrade to Pro';

  @override
  String get subscriptionFree => 'Free';

  @override
  String get subscriptionPro => 'Pro';

  @override
  String subscriptionMonthly(int price) {
    return '৳$price/month';
  }

  @override
  String subscriptionAnnual(int price) {
    return '৳$price/year';
  }

  @override
  String get subscriptionCurrentPlan => 'Current plan';

  @override
  String get subscriptionUpgrade => 'Upgrade now';

  @override
  String get subscriptionCancel => 'Cancel subscription';

  @override
  String get bestCardTitle => 'Best card for this';

  @override
  String get bestCardSubtitle => 'Based on your registered cards';

  @override
  String get bestCardSaving => 'You could save';

  @override
  String get bestCardNoCards => 'Add cards to get a suggestion';

  @override
  String get compareTitle => 'Compare cards';

  @override
  String get compareSelect => 'Select cards to compare';

  @override
  String get comparePotentialSavings => 'Potential savings';

  @override
  String get errorNetwork => 'No internet connection.';

  @override
  String get errorTimeout => 'Request timed out.';

  @override
  String get errorUnauthorized => 'Session expired. Please log in again.';

  @override
  String get errorServer => 'Something went wrong on our end.';

  @override
  String get errorGeneric => 'An unexpected error occurred.';

  @override
  String get errorCardLimit => 'Upgrade to Pro to add more cards.';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryTravel => 'Travel';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryGroceries => 'Groceries';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryHealth => 'Health';

  @override
  String daysLeft(int count) {
    return '${count}d left';
  }

  @override
  String untilDate(String date) {
    return 'Until $date';
  }

  @override
  String amountBdt(String amount) {
    return '৳$amount';
  }
}
