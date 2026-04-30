import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cardibee_flutter/app/app.dart';
import 'package:cardibee_flutter/core/storage/prefs_storage.dart';
import 'package:cardibee_flutter/core/storage/token_storage.dart';
import 'package:cardibee_flutter/core/env/env.dart';
import 'package:cardibee_flutter/features/auth/domain/models/user_profile.dart';
import 'package:cardibee_flutter/features/auth/providers/auth_provider.dart';
import 'package:cardibee_flutter/mock/mock_module.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar, dark icons in light mode
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Firebase (skip in mock-only mode to avoid needing google-services.json)
  if (!Env.useMockApi) {
    await Firebase.initializeApp();
  }

  // SharedPreferences must be initialised before the provider scope
  final prefs = await SharedPreferences.getInstance();

  // In mock mode: auto-login so the app opens directly on the home screen.
  UserProfile? mockUser;
  if (Env.useMockApi) {
    // Mark onboarding done so the router never redirects to /onboarding.
    await prefs.setBool('cardibee_onboarded', true);

    // Write a fake refresh token so hasTokens() returns true.
    const _storage = FlutterSecureStorage();
    await _storage.write(
        key: 'cardibee_refresh_token', value: 'mock_refresh_preview');
    await _storage.write(
        key: 'cardibee_access_token', value: 'mock_access_preview');

    // Load the mock user profile from fixture.
    try {
      final raw = await rootBundle
          .loadString('lib/mock/fixtures/user_profile.json');
      mockUser = UserProfile.fromJson(
          json.decode(raw) as Map<String, dynamic>);
    } catch (_) {}
  }

  runApp(
    ProviderScope(
      overrides: [
        prefsStorageProvider.overrideWithValue(PrefsStorage(prefs)),
        if (Env.useMockApi) ...MockModule.overrides,
        // Pre-seed the current user so isAuthenticatedProvider is true immediately.
        if (mockUser != null)
          currentUserProvider.overrideWith((ref) => mockUser),
      ],
      child: const CardiBeeApp(),
    ),
  );
}
