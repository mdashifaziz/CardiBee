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

class AuthNewUser extends AuthState {
  const AuthNewUser();
}

class AuthOtpSent extends AuthState {
  const AuthOtpSent({
    required this.contact,
    required this.fullName,
    required this.username,
    required this.password,
    required this.groupId,
    required this.age,
    required this.gender,
    this.error,
  });

  final String contact;
  final String fullName;
  final String username;
  final String password;
  final int groupId;
  final String age;
  final String gender;
  final String? error;

  AuthOtpSent withError(String msg) => AuthOtpSent(
        contact: contact,
        fullName: fullName,
        username: username,
        password: password,
        groupId: groupId,
        age: age,
        gender: gender,
        error: msg,
      );
}

class AuthSuccess extends AuthState {
  const AuthSuccess({required this.username});
  final String username;
}
