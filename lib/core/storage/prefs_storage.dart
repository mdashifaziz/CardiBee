import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kOnboarded = 'cardibee_onboarded';
const _kTheme     = 'cardibee_theme';
const _kLanguage  = 'cardibee_language';

final class PrefsStorage {
  const PrefsStorage(this._prefs);

  final SharedPreferences _prefs;

  // Onboarding
  bool  get hasOnboarded             => _prefs.getBool(_kOnboarded) ?? false;
  Future<void> setOnboarded(bool v)  => _prefs.setBool(_kOnboarded, v);

  // Theme
  String get theme                    => _prefs.getString(_kTheme) ?? 'system';
  Future<void> setTheme(String v)     => _prefs.setString(_kTheme, v);

  // Language
  String get language                 => _prefs.getString(_kLanguage) ?? 'en';
  Future<void> setLanguage(String v)  => _prefs.setString(_kLanguage, v);
}

// Async provider — must be awaited at app startup.
final prefsStorageProvider = Provider<PrefsStorage>((ref) {
  throw UnimplementedError('Override prefsStorageProvider with an initialised instance');
});
