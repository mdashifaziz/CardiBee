import 'package:cardibee_flutter/features/auth/domain/models/user_profile.dart';

abstract interface class AuthRepository {
  /// Request OTP via SMS. Returns request_id.
  Future<({String requestId, String maskedPhone})> requestOtp({
    required String phone,
    required String purpose, // 'signup' | 'login' | 'delete_account'
  });

  /// Verify OTP and return authenticated user.
  Future<({UserProfile user, bool isNewUser})> verifyOtp({
    required String requestId,
    required String otp,
    String? fullName,
    String? fcmToken,
  });

  /// Logout — revokes refresh token.
  Future<void> logout({String? fcmToken});

  /// Delete account (requires re-auth OTP).
  Future<void> deleteAccount({
    required String requestId,
    required String otp,
  });

  /// Get current profile (from cache or network).
  Future<UserProfile> getProfile();
}
