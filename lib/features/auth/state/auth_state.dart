sealed class AuthState {
  const AuthState();
}

class AuthIdle extends AuthState {
  const AuthIdle();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}

/// API code 101 — no account exists for this identifier.
class AuthNewUser extends AuthState {
  const AuthNewUser();
}

class AuthOtpSent extends AuthState {
  const AuthOtpSent({
    required this.requestId,
    required this.maskedEmail,
    required this.username,
    required this.email,
    required this.age,
    required this.gender,
    this.error,
  });
  final String requestId;
  final String maskedEmail;
  final String username;
  final String email;
  final int age;
  final String gender;
  final String? error;
}

class AuthSuccess extends AuthState {
  const AuthSuccess({required this.username});
  final String username;
}
