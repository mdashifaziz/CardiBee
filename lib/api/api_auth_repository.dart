import 'package:dio/dio.dart';
import 'package:cardibee_flutter/core/network/api_endpoints.dart';
import 'package:cardibee_flutter/core/network/error_mapper.dart';
import 'package:cardibee_flutter/features/auth/data/auth_service.dart';
import 'package:cardibee_flutter/features/auth/domain/auth_repository.dart';
import 'package:cardibee_flutter/features/auth/domain/models/user_profile.dart';

final class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository({required Dio dio, required AuthService authService})
      : _dio = dio,
        _auth = authService;

  // Main app Dio (has AuthInterceptor) — used for authenticated endpoints.
  final Dio _dio;

  // Clean Dio (no interceptors) — used for auth endpoints that need no token.
  final AuthService _auth;

  @override
  Future<void> sendOtp(String contact) async {
    try {
      await _auth.sendOtp(contact);
    } catch (e) {
      throw mapError(e);
    }
  }

  @override
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
  }) async {
    try {
      final data = await _auth.verifyOtpAndSignup(
        contact: contact,
        otp: otp,
        fullName: fullName,
        username: username,
        password: password,
        groupId: groupId,
        age: age,
        gender: gender,
      );
      return (
        accessToken: data['access'] as String,
        refreshToken: data['refresh'] as String,
        username: data['username'] as String,
      );
    } catch (e) {
      throw mapError(e);
    }
  }

  @override
  Future<({String accessToken, String refreshToken, String username})> login({
    required String username,
    required String password,
  }) async {
    try {
      final data = await _auth.login(username: username, password: password);
      return (
        accessToken: data['access'] as String,
        refreshToken: data['refresh'] as String,
        username: data['username'] as String,
      );
    } catch (e) {
      throw mapError(e);
    }
  }

  @override
  Future<void> logout({String? fcmToken}) async {
    try {
      await _dio.post<void>('/api/auth/logout/', data: {
        if (fcmToken != null) 'fcm_token': fcmToken,
      });
    } catch (_) {
      // Logout errors are non-fatal — caller clears tokens regardless.
    }
  }

  @override
  Future<UserProfile> getProfile() async {
    try {
      final res = await _dio.get<dynamic>(ApiEndpoints.protectedData);
      return UserProfile.fromJson(res.data as Map<String, dynamic>);
    } catch (e) {
      throw mapError(e);
    }
  }
}
