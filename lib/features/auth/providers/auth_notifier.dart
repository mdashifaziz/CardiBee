import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/core/storage/token_storage.dart';
import 'package:cardibee_flutter/features/auth/domain/auth_repository.dart';
import 'package:cardibee_flutter/features/auth/providers/auth_provider.dart';
import 'package:cardibee_flutter/features/auth/state/auth_state.dart';

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthIdle();

  Future<void> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final result = await ref.read(authRepositoryProvider).login(
        usernameOrEmail: usernameOrEmail,
        password: password,
      );
      await ref.read(tokenStorageProvider).saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      state = AuthSuccess(username: result.username);
    } on AuthNewUserException {
      state = const AuthNewUser();
    } catch (e) {
      state = AuthError(_message(e));
    }
  }

  Future<void> requestSignupOtp({
    required String username,
    required String email,
    required int age,
    required String gender,
  }) async {
    state = const AuthLoading();
    try {
      final result = await ref.read(authRepositoryProvider).requestSignupOtp(
        username: username,
        email: email,
        age: age,
        gender: gender,
      );
      state = AuthOtpSent(
        requestId: result.requestId,
        maskedEmail: result.maskedEmail,
        username: username,
        email: email,
        age: age,
        gender: gender,
      );
    } catch (e) {
      state = AuthError(_message(e));
    }
  }

  Future<void> verifySignupOtp({
    required String requestId,
    required String otp,
  }) async {
    final prev = state;
    state = const AuthLoading();
    try {
      final result = await ref.read(authRepositoryProvider).verifySignupOtp(
        requestId: requestId,
        otp: otp,
      );
      await ref.read(tokenStorageProvider).saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      state = AuthSuccess(username: result.username);
    } catch (e) {
      if (prev is AuthOtpSent) {
        state = AuthOtpSent(
          requestId: prev.requestId,
          maskedEmail: prev.maskedEmail,
          username: prev.username,
          email: prev.email,
          age: prev.age,
          gender: prev.gender,
          error: _message(e),
        );
      } else {
        state = AuthError(_message(e));
      }
    }
  }

  void reset() => state = const AuthIdle();

  static String _message(Object e) => e.toString().replaceFirst('Exception: ', '');
}
