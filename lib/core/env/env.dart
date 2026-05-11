// Configuration read from --dart-define at build time.
// Defaults are safe for local mock-only development.
// abstract final class Env {
//   static const bool useMockApi = bool.fromEnvironment('USE_MOCK_API', defaultValue: false);

//   static const String _env = String.fromEnvironment('ENV', defaultValue: 'dev');

//   static bool get isDev     => _env == 'dev';
//   static bool get isStaging => _env == 'staging';
//   static bool get isProd    => _env == 'prod';

//   static String get apiBaseUrl {
//     return switch (_env) {
//       'prod'    => 'https://motosnapai-production.up.railway.app/',
//       'staging' => 'https://motosnapai-production.up.railway.app/',
//       _         => 'https://motosnapai-production.up.railway.app/',
//     };
//   }

//   static Duration get connectTimeout => const Duration(seconds: 5);
//   static Duration get receiveTimeout => const Duration(seconds: 5);

//   // Number of retry attempts for transient network errors.
//   static int get maxRetries => 2;
// }

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

// Configuration read from --dart-define at build time.
// Defaults are safe for local mock-only development.
abstract final class Env {
  static const bool useMockApi = bool.fromEnvironment('USE_MOCK_API', defaultValue: false);

  static const String _env = String.fromEnvironment('ENV', defaultValue: 'dev');

  static bool get isDev     => _env == 'dev';
  static bool get isStaging => _env == 'staging';
  static bool get isProd    => _env == 'prod';

  static String get apiBaseUrl {
    // 1. LOCAL DEVELOPMENT
    if (isDev) {
      // Flutter Web uses standard localhost
      if (kIsWeb) {
        return 'http://127.0.0.1:8000/';
      }
      // Android Emulator uses a special alias to reach your computer's localhost
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8000/';
      }
      // iOS Simulator uses standard localhost
      return 'http://127.0.0.1:8000/';
    }

    // 2. PRODUCTION / STAGING
    return switch (_env) {
      'prod'    => 'https://motosnapai-production.up.railway.app/',
      'staging' => 'https://motosnapai-production.up.railway.app/', // Update if you create a staging backend
      _         => 'http://10.0.2.2:8000/', // Fallback
    };
  }

  static Duration get connectTimeout => const Duration(seconds: 5);
  static Duration get receiveTimeout => const Duration(seconds: 5);

  // Number of retry attempts for transient network errors.
  static int get maxRetries => 2;
}