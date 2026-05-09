import 'package:dio/dio.dart';
import 'package:cardibee_flutter/core/network/api_endpoints.dart';
import 'package:cardibee_flutter/core/storage/token_storage.dart';

// Attaches Bearer token, silently refreshes on 401, then retries once.
// On second 401 (after refresh attempt) → clears tokens and fires
// [onForceLogout] so the router can redirect to /auth.
final class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio dio,
    required void Function() onForceLogout,
  })  : _storage = tokenStorage,
        _dio = dio,
        _onForceLogout = onForceLogout;

  final TokenStorage _storage;
  final Dio _dio;
  final void Function() _onForceLogout;

  bool _isRefreshing = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.readAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra['_retried'] == true;

    if (!isUnauthorized || alreadyRetried || _isRefreshing) {
      handler.next(err);
      return;
    }

    _isRefreshing = true;
    try {
      final refreshToken = await _storage.readRefreshToken();
      if (refreshToken == null) {
        _forceLogout();
        handler.next(err);
        return;
      }

      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.refreshToken,
        data: {'refresh': refreshToken},
        options: Options(extra: {'_retried': true}),
      );

      final data = response.data!;
      await _storage.saveTokens(
        accessToken:  data['access'] as String,
        refreshToken: refreshToken,
      );

      // Retry original request with new token
      final retryOptions = err.requestOptions
        ..headers['Authorization'] = 'Bearer ${data['access']}'
        ..extra['_retried'] = true;

      final retried = await _dio.fetch<dynamic>(retryOptions);
      handler.resolve(retried);
    } catch (_) {
      _forceLogout();
      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  void _forceLogout() {
    _storage.clearTokens();
    _onForceLogout();
  }
}

// Provider is wired in dio_client.dart — not exposed directly.
