import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Background / terminated-state message handler.
///
/// Must be a top-level (or static) function annotated with `@pragma`, since
/// Firebase invokes it in a separate isolate. The OS already shows the system
/// tray entry, so we only log here.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[Push] background message: ${message.messageId}');
}

/// Thin wrapper around [FirebaseMessaging].
///
/// Every call is guarded so the app keeps working when the Firebase config
/// (google-services.json) is missing — [init] just no-ops on failure and the
/// cached [token] stays null. The backend registers the token via login/signup,
/// so callers read [token] when authenticating.
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  String? _token;
  String? get token => _token;

  bool _initialised = false;

  /// Fired for foreground messages. The app layer sets this (e.g. to refresh
  /// the in-app notifications badge).
  void Function(RemoteMessage message)? onForegroundMessage;

  /// Fired when the app is opened by tapping a notification (background or
  /// terminated). The app layer sets this to deep-link to the right screen.
  void Function(RemoteMessage message)? onNotificationTap;

  // Holds a cold-start tap that arrived before the app set [onNotificationTap].
  RemoteMessage? _pendingTap;

  /// Sets the tap handler and immediately delivers any cold-start tap that was
  /// captured during [init] before the UI was ready.
  void setTapHandler(void Function(RemoteMessage message) handler) {
    onNotificationTap = handler;
    final pending = _pendingTap;
    if (pending != null) {
      _pendingTap = null;
      handler(pending);
    }
  }

  Future<void> init() async {
    if (_initialised) return;
    _initialised = true;
    try {
      final messaging = FirebaseMessaging.instance;

      await messaging.requestPermission(alert: true, badge: true, sound: true);

      _token = await messaging.getToken();
      debugPrint('[Push] FCM token: $_token');

      messaging.onTokenRefresh.listen((t) {
        _token = t;
        debugPrint('[Push] token refreshed');
        // Re-registration happens on the next login (backend registers there).
      });

      FirebaseMessaging.onMessage.listen((m) {
        debugPrint('[Push] foreground: ${m.notification?.title}');
        onForegroundMessage?.call(m);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((m) {
        debugPrint('[Push] opened from background: ${m.notification?.title}');
        onNotificationTap?.call(m);
      });

      // Cold start via a notification tap — stash it if the UI isn't ready yet.
      final initial = await messaging.getInitialMessage();
      if (initial != null) {
        if (onNotificationTap != null) {
          onNotificationTap!(initial);
        } else {
          _pendingTap = initial;
        }
      }
    } catch (e) {
      debugPrint('[Push] init skipped (Firebase not configured?): $e');
    }
  }

  /// Re-fetch the token on demand (e.g. just before login if not cached yet).
  Future<String?> ensureToken() async {
    if (_token != null) return _token;
    try {
      _token = await FirebaseMessaging.instance.getToken();
    } catch (_) {}
    return _token;
  }

  /// Drop the device token on logout so the device stops receiving pushes.
  Future<void> deleteToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (_) {}
    _token = null;
  }
}
