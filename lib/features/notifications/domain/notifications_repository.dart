abstract interface class NotificationsRepository {
  Future<({List<dynamic> items, String? nextCursor, int unreadCount})> listNotifications({
    bool unreadOnly = false,
    int limit = 20,
    String? cursor,
  });

  Future<void> markRead(String notificationId);

  Future<int> markAllRead();

  Future<Map<String, bool>> getPreferences();

  Future<Map<String, bool>> updatePreferences(Map<String, bool> prefs);
}
