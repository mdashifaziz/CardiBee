import 'package:cardibee_flutter/features/auth/domain/models/user_profile.dart';

sealed class AuthState {
  const AuthState();
}

class AuthIdle extends AuthState {
  const AuthIdle();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthOtpSent extends AuthState {
  const AuthOtpSent({
    required this.requestId,
    required this.maskedPhone,
    required this.isSignup,
    this.error,
  });
  final String requestId;
  final String maskedPhone;
  final bool isSignup;
  final String? error;
}

class AuthSuccess extends AuthState {
  const AuthSuccess({required this.profile, required this.isNewUser});
  final UserProfile profile;
  final bool isNewUser;
}

class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}
