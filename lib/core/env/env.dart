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

  // LAN IP of the dev machine — used by `dev-staging` so a real phone on the
  // same Wi-Fi can reach the backend running on the PC.
  static const String _lanHost =
      String.fromEnvironment('LAN_HOST', defaultValue: '192.168.0.102');

  static bool get isDev        => _env == 'dev';
  static bool get isDevStaging => _env == 'dev-staging';
  static bool get isStaging    => _env == 'staging';
  static bool get isProd       => _env == 'prod';

  static String get apiBaseUrl {
    // 1. LOCAL DEVELOPMENT (emulator / web / iOS sim → host loopback)
    if (isDev) {
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

    // 2. DEV-STAGING — real phone on the same Wi-Fi as the dev PC.
    //    Build with: flutter build apk --release --dart-define=ENV=dev-staging
    //    Override IP with: --dart-define=LAN_HOST=192.168.x.x
    //    Backend must bind to 0.0.0.0:8010 (not just localhost).
    if (isDevStaging) {
      return 'http://$_lanHost:8010/';
    }

    // 3. PRODUCTION / STAGING
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