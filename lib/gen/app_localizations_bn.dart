// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'কার্ডিবি';

  @override
  String get appTagline => 'খুঁজুন। তুলনা করুন। সাশ্রয় করুন।';

  @override
  String get appSubtitle => 'সব কার্ডের সব অফার, এক জায়গায়';

  @override
  String get splashTagline => 'খুঁজুন · তুলনা করুন · সাশ্রয় করুন';

  @override
  String get onboardingSkip => 'এড়িয়ে যান';

  @override
  String get onboardingNext => 'পরবর্তী';

  @override
  String get onboardingGetStarted => 'শুরু করুন';

  @override
  String get onboardingAlreadyHaveAccount => 'ইতিমধ্যে অ্যাকাউন্ট আছে?';

  @override
  String get onboardingLogin => 'লগ ইন করুন';

  @override
  String get onboardingSlide1Title => 'আপনার কার্ড যোগ করুন';

  @override
  String get onboardingSlide1Body =>
      'আপনার ক্রেডিট ও ডেবিট কার্ড সেভ করুন। আমরা কখনো কার্ড নম্বর চাই না — শুধু ব্যাংক, নেটওয়ার্ক ও ধরন।';

  @override
  String get onboardingSlide2Title => 'সব অফার দেখুন';

  @override
  String get onboardingSlide2Body =>
      'খাবার, ভ্রমণ, কেনাকাটা সহ সব ধরনের ছাড়, ক্যাশব্যাক ও বিশেষ অফার আপনার কার্ড অনুযায়ী খুঁজে পান।';

  @override
  String get onboardingSlide3Title => 'কোনো ডিল মিস করবেন না';

  @override
  String get onboardingSlide3Body =>
      'অফার শেষ হওয়ার আগেই সতর্কতা পান এবং সব সময় সেরা মূল্যের কার্ড বেছে নিন।';

  @override
  String get authCreateAccount => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get authWelcomeBack => 'আবার স্বাগতম';

  @override
  String get authStartSaving => 'প্রতিটি সোয়াইপে সাশ্রয় শুরু করুন';

  @override
  String get authLoginSubtitle => 'আপনার ডিল দেখতে লগ ইন করুন';

  @override
  String get authPhone => 'মোবাইল নম্বর';

  @override
  String get authPhoneHint => '+৮৮০ ১X XXXX XXXX';

  @override
  String get authName => 'পুরো নাম';

  @override
  String get authNameHint => 'আপনার পুরো নাম';

  @override
  String get authSendOtp => 'OTP পাঠান';

  @override
  String get authVerifyOtp => 'OTP যাচাই করুন';

  @override
  String authOtpSentTo(String phone) {
    return '$phone-এ OTP পাঠানো হয়েছে';
  }

  @override
  String get authEnterOtp => '৬-সংখ্যার কোড লিখুন';

  @override
  String get authResendOtp => 'OTP পুনরায় পাঠান';

  @override
  String get authContinueWithGoogle => 'Google দিয়ে চালিয়ে যান';

  @override
  String get authNewToCardibee => 'কার্ডিবিতে নতুন?';

  @override
  String get authSignUp => 'সাইন আপ করুন';

  @override
  String get authCreateBtn => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get authLoginBtn => 'লগ ইন করুন';

  @override
  String get authSecurityNote =>
      '🔒 আমরা আপনার ডেটা শেয়ার করি না বা কার্ডের তথ্য চাই না।';

  @override
  String get homeGreeting => 'হ্যালো, আবার স্বাগতম';

  @override
  String homeHi(String name) {
    return 'হ্যালো, $name 👋';
  }

  @override
  String get homeSearchPlaceholder => 'মার্চেন্ট, ব্যাংক বা অফার খুঁজুন';

  @override
  String get homeWalletLabel => 'আপনার ওয়ালেট';

  @override
  String homeCardsCount(int count) {
    return '$countটি কার্ড';
  }

  @override
  String homeActiveOffersCount(int count) {
    return 'আপনার জন্য $countটি অফার সক্রিয়';
  }

  @override
  String get homeViewCards => 'দেখুন';

  @override
  String get homeBrowseByCategory => 'বিভাগ অনুযায়ী দেখুন';

  @override
  String get homeFeaturedOffers => 'বিশেষ অফার ✨';

  @override
  String get homeExpiringSoon => 'শেষ হচ্ছে শীঘ্রই';

  @override
  String get homeSeeAll => 'সব দেখুন';

  @override
  String get myOffersTitle => 'আমার অফার';

  @override
  String myOffersSubtitle(int count) {
    return 'আপনার কার্ডে $countটি ডিল';
  }

  @override
  String get myOffersEmpty => 'শুরু করতে একটি কার্ড যোগ করুন';

  @override
  String get myOffersEmptyBody =>
      'কার্ড যোগ করলে আমরা আপনার ওয়ালেটের সাথে মিলিয়ে সব অফার দেখাব।';

  @override
  String get myOffersAddCard => 'কার্ড যোগ করুন';

  @override
  String get myOffersFilterAll => 'সব';

  @override
  String myOffersResults(int count) {
    return '$countটি ফলাফল';
  }

  @override
  String get myOffersSort => 'সাজান';

  @override
  String get myOffersSortExpiring => 'শেষ হচ্ছে শীঘ্রই';

  @override
  String get myOffersSortNewest => 'সর্বশেষ';

  @override
  String get myOffersSortHighest => 'সর্বোচ্চ ছাড়';

  @override
  String get browseTitle => 'সব অফার দেখুন';

  @override
  String get browseSubtitle => 'ক্যাটালগের প্রতিটি ডিল আবিষ্কার করুন';

  @override
  String get browseSearchPlaceholder => 'মার্চেন্ট বা বিভাগ খুঁজুন';

  @override
  String get browseNoResults => 'আপনার অনুসন্ধানের সাথে কোনো অফার মেলেনি।';

  @override
  String get offerDetailValidUntil => 'বৈধ তারিখ পর্যন্ত';

  @override
  String get offerDetailMinSpend => 'সর্বনিম্ন খরচ';

  @override
  String get offerDetailMaxOff => 'সর্বোচ্চ ছাড়';

  @override
  String get offerDetailNone => 'নেই';

  @override
  String get offerDetailApplicableOn => 'যে কার্ডে প্রযোজ্য';

  @override
  String offerDetailYourCardsQualify(int count) {
    return 'আপনার $countটি কার্ড যোগ্য';
  }

  @override
  String get offerDetailYourCard => 'আপনার কার্ড';

  @override
  String get offerDetailAbout => 'এই অফার সম্পর্কে';

  @override
  String get offerDetailTerms => 'শর্তাবলী';

  @override
  String get offerDetailSecurityNote =>
      '🔒 কার্ডিবি কোনো পেমেন্ট প্রক্রিয়া করে না বা আপনার ব্যাংকের সাথে সংযুক্ত হয় না।';

  @override
  String get offerDetailVisitMerchant => 'মার্চেন্টে যান';

  @override
  String get offerDetailShare => 'শেয়ার করুন';

  @override
  String get cardsTitle => 'আমার কার্ড';

  @override
  String cardsSubtitle(int count) {
    return '$countটি কার্ড সেভ করা · কোনো কার্ড নম্বর সংরক্ষিত নয়';
  }

  @override
  String cardsActiveOffers(int count) {
    return '$countটি সক্রিয় অফার';
  }

  @override
  String get cardsTapToView => 'দেখতে ট্যাপ করুন';

  @override
  String get cardsAddCard => 'কার্ড যোগ করুন';

  @override
  String get cardsDeleteCard => 'মুছুন';

  @override
  String get addCardTitle => 'নতুন কার্ড যোগ করুন';

  @override
  String addCardStep(int current, int total) {
    return 'ধাপ $current / $total';
  }

  @override
  String get addCardChooseBank => 'আপনার ব্যাংক বেছে নিন';

  @override
  String get addCardPickProduct => 'আপনার কার্ড পণ্য বেছে নিন';

  @override
  String get addCardDetails => 'কার্ডের বিবরণ';

  @override
  String get addCardNetwork => 'নেটওয়ার্ক';

  @override
  String get addCardType => 'ধরন';

  @override
  String get addCardNickname => 'ডাকনাম (ঐচ্ছিক)';

  @override
  String get addCardNicknameHint => 'যেমন: ডেইলি ড্রাইভার';

  @override
  String get addCardLast4 => 'শেষ ৪ সংখ্যা (ঐচ্ছিক)';

  @override
  String get addCardLast4Hint => '০০০০';

  @override
  String get addCardSecurityNote =>
      '🔒 আমরা কখনো পূর্ণ কার্ড নম্বর, CVV বা PIN চাই না।';

  @override
  String get addCardContinue => 'চালিয়ে যান';

  @override
  String get addCardPickStyle => 'একটি স্টাইল বেছে নিন';

  @override
  String get addCardSave => 'কার্ড সেভ করুন';

  @override
  String get addCardCredit => 'ক্রেডিট';

  @override
  String get addCardDebit => 'ডেবিট';

  @override
  String get favoritesTitle => 'পছন্দের অফার';

  @override
  String favoritesSubtitle(int count) {
    return '$countটি সেভ করা অফার';
  }

  @override
  String get favoritesEmpty =>
      'এখনো কোনো পছন্দ নেই — যেকোনো অফারে হার্ট আইকন ট্যাপ করে সেভ করুন।';

  @override
  String get profileTitle => 'প্রোফাইল';

  @override
  String get profileCards => 'কার্ড';

  @override
  String get profileSaved => 'সেভ করা';

  @override
  String get profileSavingsYtd => 'এ বছর সাশ্রয়';

  @override
  String get profileDarkMode => 'ডার্ক মোড';

  @override
  String get profileLightMode => 'লাইট মোড';

  @override
  String get profileOn => 'চালু';

  @override
  String get profileOff => 'বন্ধ';

  @override
  String get profileMyCards => 'আমার কার্ড';

  @override
  String get profileFavorites => 'পছন্দের অফার';

  @override
  String get profileNotifications => 'নোটিফিকেশন';

  @override
  String get profilePrivacy => 'গোপনীয়তা ও নিরাপত্তা';

  @override
  String get profileTerms => 'সেবার শর্তাবলী';

  @override
  String get profileAbout => 'কার্ডিবি সম্পর্কে';

  @override
  String get profileLogOut => 'লগ আউট';

  @override
  String get profileVersion => 'কার্ডিবি v১.০ · 🇧🇩-এ তৈরি';

  @override
  String get notificationsTitle => 'নোটিফিকেশন';

  @override
  String get notificationsMarkAllRead => 'সব পঠিত করুন';

  @override
  String get notificationsEmpty => 'সব নোটিফিকেশন পড়া হয়েছে!';

  @override
  String get subscriptionTitle => 'প্রো-তে আপগ্রেড করুন';

  @override
  String get subscriptionFree => 'ফ্রি';

  @override
  String get subscriptionPro => 'প্রো';

  @override
  String subscriptionMonthly(int price) {
    return '৳$price/মাস';
  }

  @override
  String subscriptionAnnual(int price) {
    return '৳$price/বছর';
  }

  @override
  String get subscriptionCurrentPlan => 'বর্তমান প্ল্যান';

  @override
  String get subscriptionUpgrade => 'এখনই আপগ্রেড করুন';

  @override
  String get subscriptionCancel => 'সাবস্ক্রিপশন বাতিল করুন';

  @override
  String get bestCardTitle => 'এর জন্য সেরা কার্ড';

  @override
  String get bestCardSubtitle => 'আপনার নিবন্ধিত কার্ডের উপর ভিত্তি করে';

  @override
  String get bestCardSaving => 'আপনি সাশ্রয় করতে পারবেন';

  @override
  String get bestCardNoCards => 'সাজেশন পেতে কার্ড যোগ করুন';

  @override
  String get compareTitle => 'কার্ড তুলনা করুন';

  @override
  String get compareSelect => 'তুলনার জন্য কার্ড বেছে নিন';

  @override
  String get comparePotentialSavings => 'সম্ভাব্য সাশ্রয়';

  @override
  String get errorNetwork => 'ইন্টারনেট সংযোগ নেই।';

  @override
  String get errorTimeout => 'অনুরোধের সময় শেষ হয়েছে।';

  @override
  String get errorUnauthorized => 'সেশন শেষ হয়েছে। আবার লগ ইন করুন।';

  @override
  String get errorServer => 'আমাদের সার্ভারে সমস্যা হয়েছে।';

  @override
  String get errorGeneric => 'একটি অপ্রত্যাশিত ত্রুটি হয়েছে।';

  @override
  String get errorCardLimit => 'আরও কার্ড যোগ করতে প্রো-তে আপগ্রেড করুন।';

  @override
  String get categoryFood => 'খাবার';

  @override
  String get categoryTravel => 'ভ্রমণ';

  @override
  String get categoryShopping => 'কেনাকাটা';

  @override
  String get categoryGroceries => 'মুদিখানা';

  @override
  String get categoryEntertainment => 'বিনোদন';

  @override
  String get categoryHealth => 'স্বাস্থ্য';

  @override
  String daysLeft(int count) {
    return '$count দিন বাকি';
  }

  @override
  String untilDate(String date) {
    return '$date পর্যন্ত';
  }

  @override
  String amountBdt(String amount) {
    return '৳$amount';
  }
}
