import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cardibee_flutter/features/auth/domain/auth_repository.dart';
import 'package:cardibee_flutter/features/auth/domain/models/user_profile.dart';

// Mock auth always succeeds. OTP "123456" is the magic test code.
final class MockAuthRepository implements AuthRepository {
  UserProfile? _profile;

  Future<UserProfile> _loadProfile() async {
    if (_profile != null) return _profile!;
    final raw = await rootBundle.loadString('lib/mock/fixtures/user_profile.json');
    _profile = UserProfile.fromJson(json.decode(raw) as Map<String, dynamic>);
    return _profile!;
  }

  @override
  Future<({String requestId, String maskedPhone})> requestOtp({
    required String phone,
    required String purpose,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final masked = phone.length >= 4
        ? '+880 1X XXXX XX${phone.substring(phone.length - 2)}'
        : phone;
    return (requestId: 'mock_req_123', maskedPhone: masked);
  }

  @override
  Future<({UserProfile user, bool isNewUser})> verifyOtp({
    required String requestId,
    required String otp,
    String? fullName,
    String? fcmToken,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Any OTP works in mock mode
    final user = await _loadProfile();
    final resolved = fullName != null ? user.copyWith(fullName: fullName) : user;
    return (user: resolved, isNewUser: false);
  }

  @override
  Future<void> logout({String? fcmToken}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _profile = null;
  }

  @override
  Future<void> deleteAccount({required String requestId, required String otp}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _profile = null;
  }

  @override
  Future<UserProfile> getProfile() => _loadProfile();
}
