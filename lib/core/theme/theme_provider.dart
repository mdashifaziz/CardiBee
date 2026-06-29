import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/core/storage/prefs_storage.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.watch(prefsStorageProvider);
    return switch (prefs.theme) {
      'dark'  => ThemeMode.dark,
      'light' => ThemeMode.light,
      _       => ThemeMode.system,
    };
  }

  void toggle() {
    // Resolve the *actual* brightness, accounting for system mode, so the
    // first toggle always flips what the user currently sees.
    final isDarkNow = switch (state) {
      ThemeMode.dark  => true,
      ThemeMode.light => false,
      ThemeMode.system =>
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark,
    };
    final next = isDarkNow ? ThemeMode.light : ThemeMode.dark;
    state = next;
    ref.read(prefsStorageProvider).setTheme(next == ThemeMode.dark ? 'dark' : 'light');
  }

  bool get isDark => state == ThemeMode.dark;
}
