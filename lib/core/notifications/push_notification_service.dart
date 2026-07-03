import 'dart:convert';
import 'dart:ui' show Color;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
///
/// Foreground messages are displayed via [FlutterLocalNotificationsPlugin]
/// (FCM only auto-shows tray entries when the app is backgrounded/killed).
/// Tapping one carries the FCM data payload through and re-enters the same
/// [onNotificationTap] path as background taps.
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  // Must match the channel created in MainActivity.kt and the
  // default_notification_channel_id meta-data in AndroidManifest.xml.
  static const _channelId = 'cardibee_default';
  static const _channelName = 'General';
  static const _channelDescription = 'Offer alerts and reminders';

  final _local = FlutterLocalNotificationsPlugin();

  String? _token;
  String? get token => _token;

  bool _initialised = false;

  /// Fired for foreground messages. The app layer sets this (e.g. to refresh
  /// the in-app notifications badge).
  void Function(RemoteMessage message)? onForegroundMessage;

  /// Fired when FCM rotates the token. The app layer sets this to re-register
  /// the new token with the backend (when a session exists).
  void Function(String token)? onTokenRefreshed;

  /// Fired when the app is opened by tapping a notification (background,
  /// terminated, or a locally shown foreground one). The app layer sets this
  /// to deep-link to the right screen.
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

      await _initLocalNotifications();

      _token = await messaging.getToken();
      debugPrint('[Push] FCM token: $_token');

      messaging.onTokenRefresh.listen((t) {
        _token = t;
        debugPrint('[Push] token refreshed');
        onTokenRefreshed?.call(t);
      });

      FirebaseMessaging.onMessage.listen((m) {
        debugPrint('[Push] foreground: ${m.notification?.title}');
        _showForeground(m);
        onForegroundMessage?.call(m);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((m) {
        debugPrint('[Push] opened from background: ${m.notification?.title}');
        _dispatchTap(m);
      });

      // Cold start via a notification tap — stash it if the UI isn't ready yet.
      final initial = await messaging.getInitialMessage();
      if (initial != null) _dispatchTap(initial);
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

  // ---------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------

  void _dispatchTap(RemoteMessage message) {
    if (onNotificationTap != null) {
      onNotificationTap!(message);
    } else {
      _pendingTap = message;
    }
  }

  Future<void> _initLocalNotifications() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_notification'),
    );
    await _local.initialize(
      settings,
      onDidReceiveNotificationResponse: _onLocalTap,
    );

    // A tap on a locally shown notification can also cold-start the app.
    final launch = await _local.getNotificationAppLaunchDetails();
    final response = launch?.notificationResponse;
    if ((launch?.didNotificationLaunchApp ?? false) && response != null) {
      _onLocalTap(response);
    }
  }

  void _onLocalTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final data = Map<String, dynamic>.from(
          json.decode(payload) as Map<dynamic, dynamic>);
      _dispatchTap(RemoteMessage(data: data.cast<String, String>()));
    } catch (e) {
      debugPrint('[Push] bad local-notification payload: $e');
    }
  }

  /// FCM only shows tray entries automatically when the app is in the
  /// background — in the foreground we display it ourselves.
  Future<void> _showForeground(RemoteMessage m) async {
    final title = m.notification?.title ?? m.data['title'] as String?;
    final body = m.notification?.body ?? m.data['body'] as String?;
    if (title == null && body == null) return;
    try {
      await _local.show(
        int.tryParse(m.data['recipient_id']?.toString() ?? '') ?? m.hashCode,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@drawable/ic_notification',
            color: Color(0xFFF4B400), // bee yellow, matches notification_color
          ),
        ),
        payload: json.encode(m.data),
      );
    } catch (e) {
      debugPrint('[Push] foreground display failed: $e');
    }
  }
}
