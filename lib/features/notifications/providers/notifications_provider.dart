import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/features/notifications/domain/notifications_repository.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  throw UnimplementedError('notificationsRepositoryProvider must be overridden');
});

/// Live unread-notification count, surfaced on the home bell badge.
/// Refreshed on app start, when a push arrives, and after marking read.
final unreadCountProvider =
    NotifierProvider<UnreadCountNotifier, int>(UnreadCountNotifier.new);

class UnreadCountNotifier extends Notifier<int> {
  @override
  int build() {
    refresh();
    return 0;
  }

  Future<void> refresh() async {
    try {
      final r = await ref
          .read(notificationsRepositoryProvider)
          .listNotifications(limit: 1);
      state = r.unreadCount;
    } catch (_) {
      // Keep the last known count on failure.
    }
  }

  void set(int value) => state = value < 0 ? 0 : value;
  void clear() => state = 0;
}
