import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/features/auth/domain/auth_repository.dart';
import 'package:cardibee_flutter/features/auth/domain/models/user_profile.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError('authRepositoryProvider must be overridden');
});

// Current user — null when unauthenticated
final currentUserProvider = StateProvider<UserProfile?>((ref) => null);

// Derived — true when a user object is present
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});
