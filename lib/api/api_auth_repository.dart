import 'package:dio/dio.dart';
import 'package:cardibee_flutter/core/network/error_mapper.dart';
import 'package:cardibee_flutter/features/auth/domain/auth_repository.dart';
import 'package:cardibee_flutter/features/auth/domain/models/user_profile.dart';

final class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._dio);
  final Dio _dio;

  @override
  Future<({String accessToken, String refreshToken, String username})> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      final res = await _dio.post<dynamic>('/auth/login', data: {
        'username_or_email': usernameOrEmail,
        'password': password,
      });
      final data = _unwrap(res.data) as Map<String, dynamic>;
      return (
        accessToken:  data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
        username:     data['username'] as String,
      );
    } on DioException catch (e) {
      // API returns 404 or body code '101' when account doesn't exist
      final body = e.response?.data;
      final code = body is Map ? body['code']?.toString() : null;
      if (e.response?.statusCode == 404 || code == '101' || code == 'user_not_found') {
        throw const AuthNewUserException();
      }
      throw mapDioError(e);
    }
  }

  @override
  Future<({String requestId, String maskedEmail})> requestSignupOtp({
    required String username,
    required String email,
    required int age,
    required String gender,
  }) async {
    try {
      final res = await _dio.post<dynamic>('/auth/signup/request-otp', data: {
        'username': username,
        'email': email,
        'age': age,
        'gender': gender,
      });
      final data = _unwrap(res.data) as Map<String, dynamic>;
      return (
        requestId:   data['request_id'] as String,
        maskedEmail: data['masked_email'] as String,
      );
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<({String accessToken, String refreshToken, String username})> verifySignupOtp({
    required String requestId,
    required String otp,
  }) async {
    try {
      final res = await _dio.post<dynamic>('/auth/signup/verify-otp', data: {
        'request_id': requestId,
        'otp': otp,
      });
      final data = _unwrap(res.data) as Map<String, dynamic>;
      return (
        accessToken:  data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
        username:     data['username'] as String,
      );
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<void> logout({String? fcmToken}) async {
    try {
      await _dio.post<void>('/auth/logout', data: {
        if (fcmToken != null) 'fcm_token': fcmToken,
      });
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<UserProfile> getProfile() async {
    try {
      final res = await _dio.get<dynamic>('/auth/me');
      return UserProfile.fromJson(_unwrap(res.data) as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  dynamic _unwrap(dynamic raw) {
    if (raw is Map<String, dynamic> && raw.containsKey('data')) return raw['data'];
    return raw;
  }
}
