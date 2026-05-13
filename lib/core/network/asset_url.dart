import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

// Backend (Django) may return absolute URLs with host `localhost` or `127.0.0.1`.
// On Android emulator those don't resolve to the host machine — the emulator
// alias `10.0.2.2` does. This helper rewrites such URLs at render time so
// images served by the local dev backend display correctly on Android.
String resolveAssetUrl(String url) {
  if (kIsWeb || !Platform.isAndroid) return url;
  return url
      .replaceFirst('://localhost', '://10.0.2.2')
      .replaceFirst('://127.0.0.1', '://10.0.2.2');
}
