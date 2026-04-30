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

  Future<void> requestOtp({
    required String phone,
    required bool isSignup,
  }) async {
    state = const AuthLoading();
    try {
      final result = await ref.read(authRepositoryProvider).requestOtp(
        phone: _normalisePhone(phone),
        purpose: isSignup ? 'signup' : 'login',
      );
      state = AuthOtpSent(
        requestId: result.requestId,
        maskedPhone: result.maskedPhone,
        isSignup: isSignup,
      );
    } catch (e) {
      state = AuthError(_message(e));
    }
  }

  Future<void> verifyOtp({
    required String requestId,
    required String otp,
    String? fullName,
  }) async {
    state = const AuthLoading();
    try {
      final result = await ref.read(authRepositoryProvider).verifyOtp(
        requestId: requestId,
        otp: otp,
        fullName: fullName,
      );
      // Persist fake tokens so the router guard is satisfied in mock mode too
      await ref.read(tokenStorageProvider).saveTokens(
        accessToken:  'access_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'refresh_${DateTime.now().millisecondsSinceEpoch}',
      );
      ref.read(currentUserProvider.notifier).state = result.user;
      state = AuthSuccess(profile: result.user, isNewUser: result.isNewUser);
    } catch (e) {
      // Return to OTP entry state with inline error
      final prev = state;
      if (prev is AuthOtpSent) {
        state = AuthOtpSent(
          requestId: prev.requestId,
          maskedPhone: prev.maskedPhone,
          isSignup: prev.isSignup,
          error: _message(e),
        );
      } else {
        state = AuthError(_message(e));
      }
    }
  }

  void backToPhone() => state = const AuthIdle();

  void clearError() {
    final s = state;
    if (s is AuthOtpSent) {
      state = AuthOtpSent(
        requestId: s.requestId,
        maskedPhone: s.maskedPhone,
        isSignup: s.isSignup,
      );
    } else {
      state = const AuthIdle();
    }
  }

  // Strip spaces, dashes; normalise 01X → +8801X
  static String _normalisePhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('880')) return '+$digits';
    if (digits.startsWith('0'))   return '+880${digits.substring(1)}';
    return '+880$digits';
  }

  static String _message(Object e) => e.toString().replaceFirst('Exception: ', '');
}
