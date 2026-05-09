// Dart 3 sealed class — no code generation required.
// Every repository must map its exceptions to one of these before
// crossing the domain boundary.
sealed class AppFailure {
  const AppFailure();
  String get displayMessage;
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure([this.message = 'No internet connection.']);
  final String message;
  @override
  String get displayMessage => message;
}

final class TimeoutFailure extends AppFailure {
  const TimeoutFailure([this.message = 'Request timed out.']);
  final String message;
  @override
  String get displayMessage => message;
}

final class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure([this.message = 'Session expired. Please log in again.']);
  final String message;
  @override
  String get displayMessage => message;
}

final class ForbiddenFailure extends AppFailure {
  const ForbiddenFailure([this.message = 'You do not have access to this resource.']);
  final String message;
  @override
  String get displayMessage => message;
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure([this.message = 'The requested resource was not found.']);
  final String message;
  @override
  String get displayMessage => message;
}

final class ServerFailure extends AppFailure {
  const ServerFailure({this.message = 'Something went wrong on our end.', this.statusCode});
  final String message;
  final int? statusCode;
  @override
  String get displayMessage => message;
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure({
    this.message = 'Please check the highlighted fields.',
    this.fieldErrors = const {},
  });
  final String message;
  final Map<String, List<String>> fieldErrors;
  @override
  String get displayMessage => message;
}

final class CardLimitFailure extends AppFailure {
  const CardLimitFailure([this.message = 'Upgrade to Pro to add more cards.']);
  final String message;
  @override
  String get displayMessage => message;
}

final class ServerSleepingFailure extends AppFailure {
  const ServerSleepingFailure(
      [this.message = 'Server is sleeping. Please try again in a moment.']);
  final String message;
  @override
  String get displayMessage => message;
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure([this.message = 'An unexpected error occurred.']);
  final String message;
  @override
  String get displayMessage => message;
}
