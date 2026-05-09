// Configuration read from --dart-define at build time.
// Defaults are safe for local mock-only development.
abstract final class Env {
  static const bool useMockApi = bool.fromEnvironment('USE_MOCK_API', defaultValue: false);

  static const String _env = String.fromEnvironment('ENV', defaultValue: 'dev');

  static bool get isDev     => _env == 'dev';
  static bool get isStaging => _env == 'staging';
  static bool get isProd    => _env == 'prod';

  static String get apiBaseUrl {
    return switch (_env) {
      'prod'    => 'https://api.cardibee.app/',       // TODO: set Railway prod URL
      'staging' => 'https://api.cardibee.app/',       // TODO: set Railway staging URL
      _         => 'http://10.0.2.2:8000/',           // Android emulator → host localhost
    };
  }

  static Duration get connectTimeout => const Duration(seconds: 5);
  static Duration get receiveTimeout => const Duration(seconds: 5);

  // Number of retry attempts for transient network errors.
  static int get maxRetries => 2;
}
