import 'package:dio/dio.dart';
import 'package:cardibee_flutter/core/error/app_failure.dart';

AppFailure mapDioError(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    return const TimeoutFailure();
  }

  if (e.type == DioExceptionType.connectionError) {
    return const NetworkFailure();
  }

  final status    = e.response?.statusCode;
  final body      = e.response?.data;
  final serverMsg = _extractMessage(body);

  return switch (status) {
    400  => _handle400(body, serverMsg),
    401  => const UnauthorizedFailure(),
    403  => _handle403(body, serverMsg),
    404  => NotFoundFailure(serverMsg ?? 'Not found.'),
    422  => _handle400(body, serverMsg),
    >= 500 => ServerFailure(message: serverMsg ?? 'Server error.', statusCode: status),
    _    => UnknownFailure(serverMsg ?? 'Unexpected error.'),
  };
}

AppFailure _handle400(dynamic body, String? serverMsg) {
  if (body is Map<String, dynamic>) {
    final code = body['code'] as String?;
    if (code == 'card_limit_reached') return const CardLimitFailure();

    final details = body['details'];
    if (details is Map<String, dynamic>) {
      final fieldErrors = details.map(
        (k, v) => MapEntry(k, (v as List).cast<String>()),
      );
      return ValidationFailure(
        message: serverMsg ?? 'Validation failed.',
        fieldErrors: fieldErrors,
      );
    }
  }
  return ValidationFailure(message: serverMsg ?? 'Bad request.');
}

AppFailure _handle403(dynamic body, String? serverMsg) {
  if (body is Map<String, dynamic>) {
    if (body['code'] == 'card_limit_reached') return const CardLimitFailure();
  }
  return ForbiddenFailure(serverMsg ?? 'Access denied.');
}

String? _extractMessage(dynamic body) {
  if (body is Map<String, dynamic>) return body['message'] as String?;
  return null;
}
