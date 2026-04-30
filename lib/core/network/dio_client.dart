import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/core/env/env.dart';
import 'package:cardibee_flutter/core/storage/token_storage.dart';
import 'package:cardibee_flutter/core/network/auth_interceptor.dart';

// Callback fired when a session expires and cannot be refreshed.
// The router listens to this to redirect to /auth.
typedef ForceLogoutCallback = void Function();

final _forceLogoutCallbacks = <ForceLogoutCallback>[];

void registerForceLogoutCallback(ForceLogoutCallback cb) =>
    _forceLogoutCallbacks.add(cb);

void _notifyForceLogout() {
  for (final cb in _forceLogoutCallbacks) {
    cb();
  }
}

Dio buildDioClient(TokenStorage tokenStorage) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: Env.connectTimeout,
      receiveTimeout: Env.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Client': 'cardibee-flutter/1.0.0',
      },
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(
      tokenStorage: tokenStorage,
      dio: dio,
      onForceLogout: _notifyForceLogout,
    ),
    if (Env.isDev) _LoggingInterceptor(),
  ]);

  return dio;
}

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(tokenStorageProvider);
  return buildDioClient(storage);
});

// Minimal request/response logger — only active in dev builds.
final class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // In prod this interceptor is never added. In dev, log method + path only.
    // ignore: avoid_print
    print('[CardiBee] --> ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ignore: avoid_print
    print('[CardiBee] <-- ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print('[CardiBee] ERR ${err.response?.statusCode} ${err.requestOptions.path}');
    handler.next(err);
  }
}
