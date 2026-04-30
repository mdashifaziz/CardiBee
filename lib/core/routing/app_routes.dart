abstract final class AppRoutes {
  static const String splash       = '/';
  static const String onboarding   = '/onboarding';
  static const String auth         = '/auth';

  // Shell (bottom nav)
  static const String appShell     = '/app';
  static const String home         = '/app/home';
  static const String myOffers     = '/app/offers';
  static const String browse       = '/app/browse';
  static const String cards        = '/app/cards';
  static const String addCard      = '/app/cards/add';
  static const String profile      = '/app/profile';

  // Detail pages (no bottom nav)
  static const String offerDetail  = '/app/offer/:id';
  static const String favorites    = '/app/favorites';
  static const String bestCard     = '/app/best-card';
  static const String compare      = '/app/compare';
  static const String notifications= '/app/notifications';
  static const String subscription = '/app/subscription';

  static String offerDetailPath(String id) => '/app/offer/$id';
}
