abstract final class ApiEndpoints {
  static const String sendOtp               = 'api/auth/signup/send-otp/';
  static const String verifyOtpAndSignup    = 'api/auth/signup/verify-otp/';
  static const String login                 = 'api/auth/login/';
  static const String refreshToken          = 'api/auth/token/refresh/';
  static const String protectedData         = 'api/auth/protected/';
  static const String requestPasswordReset  = 'api/auth/password-reset/request-otp/';
  static const String verifyAndSetPassword  = 'api/auth/password-reset/verify-set/';

  static const String banks                 = 'nucleus/banks/';
  static String bankCardTypes(String bankId) => 'nucleus/banks/$bankId/card-types/';
  static const String cards                 = 'nucleus/cards/';

  static const String profile               = 'api/auth/profile/';

  static const String offersSearch          = 'nucleus/offers/search/';
  static String offer(String id)            => 'nucleus/offers/$id/';
  static String saveOffer(String id)        => 'nucleus/offers/$id/save/';
  static const String savedOffers           = 'nucleus/offers/saved/';
}
