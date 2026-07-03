abstract interface class NotificationsRepository {
  Future<({List<dynamic> items, String? nextCursor, int unreadCount})> listNotifications({
    bool unreadOnly = false,
    int limit = 20,
    String? cursor,
  });

  Future<void> markRead(String notificationId);

  /// (Re)registers this device's FCM token for the current user. Idempotent —
  /// call on every app start and on token refresh (requires a valid session).
  Future<void> registerDevice(String fcmToken);

  Future<int> markAllRead();

  Future<Map<String, bool>> getPreferences();

  Future<Map<String, bool>> updatePreferences(Map<String, bool> prefs);
}
