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
    required String username,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final result = await ref.read(authRepositoryProvider).login(
            username: username,
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

  Future<void> sendOtp({
    required String contact,
    required String fullName,
    required String username,
    required String password,
    required int groupId,
    required String age,
    required String gender,
  }) async {
    state = const AuthLoading();
    try {
      await ref.read(authRepositoryProvider).sendOtp(contact);
      state = AuthOtpSent(
        contact: contact,
        fullName: fullName,
        username: username,
        password: password,
        groupId: groupId,
        age: age,
        gender: gender,
      );
    } catch (e) {
      state = AuthError(_message(e));
    }
  }

  Future<void> verifyOtpAndSignup(String otp) async {
    final prev = state;
    if (prev is! AuthOtpSent) return;
    state = const AuthLoading();
    try {
      final result = await ref.read(authRepositoryProvider).verifyOtpAndSignup(
            contact: prev.contact,
            otp: otp,
            fullName: prev.fullName,
            username: prev.username,
            password: prev.password,
            groupId: prev.groupId,
            age: prev.age,
            gender: prev.gender,
          );
      await ref.read(tokenStorageProvider).saveTokens(
            accessToken: result.accessToken,
            refreshToken: result.refreshToken,
          );
      state = AuthSuccess(username: result.username);
    } catch (e) {
      state = prev.withError(_message(e));
    }
  }

  void reset() => state = const AuthIdle();

  static String _message(Object e) =>
      e.toString().replaceFirst('Exception: ', '');
}
