abstract final class AppRoutes {
  static const String splash        = '/';
  static const String onboarding    = '/onboarding';
  static const String auth          = '/auth';
  static const String signup        = '/signup';
  static const String otp           = '/otp';

  // Shell (bottom nav)
  static const String appShell      = '/app';
  static const String home          = '/app/home';
  static const String myOffers      = '/app/offers';
  static const String browse        = '/app/browse';
  static const String cards         = '/app/cards';
  static const String addCard       = '/app/cards/add';
  static const String profile       = '/app/profile';

  // Detail pages (no bottom nav)
  static const String offerDetail   = '/app/offer/:id';
  static const String favorites     = '/app/favorites';
  static const String bestCard      = '/app/best-card';
  static const String compare       = '/app/compare';
  static const String notifications = '/app/notifications';
  static const String subscription  = '/app/subscription';
  static const String terms         = '/app/terms';
  static const String about         = '/app/about';

  static String offerDetailPath(String id) => '/app/offer/$id';

  /// Maps a backend `link_url` (e.g. '/app/offers/123', '/app/profile', or an
  /// absolute URL) to an in-app route, or null if it can't be opened in-app.
  static String? resolveLink(String? linkUrl) {
    if (linkUrl == null || linkUrl.isEmpty) return null;
    if (linkUrl.startsWith('http')) return null; // external — needs a browser
    // Portal uses plural 'offers'; our route is singular 'offer'.
    final offer = RegExp(r'/offers?/(\w+)').firstMatch(linkUrl);
    if (offer != null) return offerDetailPath(offer.group(1)!);
    if (linkUrl.startsWith('/app/')) return linkUrl; // already an app path
    return null;
  }
}
