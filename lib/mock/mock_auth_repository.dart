import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cardibee_flutter/features/auth/domain/auth_repository.dart';
import 'package:cardibee_flutter/features/auth/domain/models/user_profile.dart';

// Mock credentials: admin / 123456  |  Mock OTP: 123456
final class MockAuthRepository implements AuthRepository {
  UserProfile? _profile;

  Future<UserProfile> _loadProfile() async {
    if (_profile != null) return _profile!;
    final raw = await rootBundle.loadString('lib/mock/fixtures/user_profile.json');
    _profile = UserProfile.fromJson(json.decode(raw) as Map<String, dynamic>);
    return _profile!;
  }

  @override
  Future<({String accessToken, String refreshToken, String username})> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (password != '123456') throw Exception('Wrong password.');
    final isKnown = usernameOrEmail == 'admin' ||
        usernameOrEmail == 'admin@cardibee.app';
    if (!isKnown) throw const AuthNewUserException();
    return (
      accessToken:  'mock_access_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_${DateTime.now().millisecondsSinceEpoch}',
      username:     'admin',
    );
  }

  @override
  Future<({String requestId, String maskedEmail})> requestSignupOtp({
    required String username,
    required String email,
    required int age,
    required String gender,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final at = email.indexOf('@');
    final masked = at > 1 ? '${email[0]}***${email.substring(at)}' : email;
    return (
      requestId:   'mock_req_${DateTime.now().millisecondsSinceEpoch}',
      maskedEmail: masked,
    );
  }

  @override
  Future<({String accessToken, String refreshToken, String username})> verifySignupOtp({
    required String requestId,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (otp != '123456') throw Exception('Invalid OTP. Hint: 123456');
    return (
      accessToken:  'mock_access_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_${DateTime.now().millisecondsSinceEpoch}',
      username:     'new_user',
    );
  }

  @override
  Future<void> logout({String? fcmToken}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _profile = null;
  }

  @override
  Future<UserProfile> getProfile() => _loadProfile();
}
