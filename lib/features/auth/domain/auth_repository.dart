import 'package:cardibee_flutter/features/auth/domain/models/user_profile.dart';

class AuthNewUserException implements Exception {
  const AuthNewUserException();
  @override
  String toString() => 'No account found. Please sign up.';
}

abstract interface class AuthRepository {
  Future<void> sendOtp(String contact);

  Future<({String accessToken, String refreshToken, String username})>
      verifyOtpAndSignup({
    required String contact,
    required String otp,
    required String fullName,
    required String username,
    required String password,
    required int groupId,
    required String age,
    required String gender,
  });

  Future<({String accessToken, String refreshToken, String username})> login({
    required String username,
    required String password,
  });

  Future<void> logout({String? fcmToken});

  Future<UserProfile> getProfile();
}
