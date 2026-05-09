import 'package:dio/dio.dart';
import 'package:cardibee_flutter/core/env/env.dart';
import 'package:cardibee_flutter/core/network/api_endpoints.dart';

class AuthService {
  AuthService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: Env.apiBaseUrl,
            connectTimeout: Env.connectTimeout,
            receiveTimeout: Env.receiveTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

  final Dio _dio;

  // 1. Send OTP (Signup)
  Future<void> sendOtp(String contact) async {
    try {
      await _dio.post<dynamic>(
        ApiEndpoints.sendOtp,
        data: {'contact': contact},
      );
    } on DioException catch (e) {
      throw Exception(_message(e) ?? 'Failed to send OTP.');
    }
  }

  // 2. Verify OTP & Create Account → returns {access, refresh, username}
  Future<Map<String, dynamic>> verifyOtpAndSignup({
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
      final res = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.verifyOtpAndSignup,
        data: {
          'contact':   contact,
          'otp':       otp,
          'full_name': fullName,
          'username':  username,
          'password':  password,
          'group_id':  groupId,
          'age':       age,
          'gender':    gender,
        },
      );
      return res.data!;
    } on DioException catch (e) {
      throw Exception(_message(e) ?? 'Signup failed.');
    }
  }

  // 3. Login → returns {access, refresh, username, full_name}
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );
      return res.data!;
    } on DioException catch (e) {
      throw Exception(_message(e) ?? 'Login failed.');
    }
  }

  // 4. Refresh Token → returns new access token string
  Future<String> refreshAccessToken(String refresh) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.refreshToken,
        data: {'refresh': refresh},
      );
      return res.data!['access'] as String;
    } on DioException catch (e) {
      throw Exception(_message(e) ?? 'Token refresh failed.');
    }
  }

  // 5. Fetch Protected User Data
  Future<Map<String, dynamic>> fetchProtectedData(String accessToken) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.protectedData,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      return res.data!;
    } on DioException catch (e) {
      throw Exception(_message(e) ?? 'Failed to fetch user data.');
    }
  }

  // 6. Request Password Reset OTP
  Future<void> requestPasswordReset(String contact) async {
    try {
      await _dio.post<dynamic>(
        ApiEndpoints.requestPasswordReset,
        data: {'contact': contact},
      );
    } on DioException catch (e) {
      throw Exception(_message(e) ?? 'Failed to request password reset.');
    }
  }

  // 7. Verify OTP & Set New Password
  Future<void> verifyAndSetPassword({
    required String contact,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await _dio.post<dynamic>(
        ApiEndpoints.verifyAndSetPassword,
        data: {
          'contact':          contact,
          'otp':              otp,
          'new_password':     newPassword,
          'confirm_password': confirmPassword,
        },
      );
    } on DioException catch (e) {
      throw Exception(_message(e) ?? 'Failed to set new password.');
    }
  }

  String? _message(DioException e) {
    final body = e.response?.data;
    if (body is Map<String, dynamic>) {
      return (body['message'] ?? body['detail'])?.toString();
    }
    return null;
  }
}
