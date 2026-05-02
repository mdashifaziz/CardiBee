import 'package:cardibee_flutter/features/auth/domain/models/user_profile.dart';

/// Thrown when login is attempted for an account that does not exist (API code 101).
class AuthNewUserException implements Exception {
  const AuthNewUserException();
  @override
  String toString() => 'No account found. Please sign up.';
}

abstract interface class AuthRepository {
  /// Login with username or email + password.
  /// Throws [AuthNewUserException] if the account does not exist (code 101).
  Future<({String accessToken, String refreshToken, String username})> login({
    required String usernameOrEmail,
    required String password,
  });

  /// Request OTP for new account signup.
  Future<({String requestId, String maskedEmail})> requestSignupOtp({
    required String username,
    required String email,
    required int age,
    required String gender,
  });

  /// Verify OTP and complete signup. Returns tokens on success.
  Future<({String accessToken, String refreshToken, String username})> verifySignupOtp({
    required String requestId,
    required String otp,
  });

  /// Logout — revokes refresh token.
  Future<void> logout({String? fcmToken});

  /// Get current profile.
  Future<UserProfile> getProfile();
}
