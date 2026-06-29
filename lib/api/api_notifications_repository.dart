import 'package:dio/dio.dart';
import 'package:cardibee_flutter/core/network/api_endpoints.dart';
import 'package:cardibee_flutter/core/network/error_mapper.dart';
import 'package:cardibee_flutter/features/notifications/domain/notifications_repository.dart';

final class ApiNotificationsRepository implements NotificationsRepository {
  ApiNotificationsRepository(this._dio);
  final Dio _dio;

  @override
  Future<({List<dynamic> items, String? nextCursor, int unreadCount})>
      listNotifications({
    bool unreadOnly = false,
    int limit = 20,
    String? cursor,
  }) async {
    try {
      final res = await _dio.get<dynamic>(ApiEndpoints.notifications, queryParameters: {
        'limit': limit,
        if (unreadOnly) 'unread_only': true,
        if (cursor != null) 'cursor': cursor,
      });
      final raw = res.data;
      List<dynamic> items;
      String? nextCursor;
      int unreadCount;
      if (raw is List) {
        items = raw;
        nextCursor = null;
        unreadCount = 0;
      } else {
        final m = raw as Map<String, dynamic>;
        items = (m['data'] ?? m['items'] ?? const <dynamic>[]) as List<dynamic>;
        nextCursor = m['next_cursor'] as String?;
        unreadCount = (m['unread_count'] ?? 0) as int;
      }
      return (items: items, nextCursor: nextCursor, unreadCount: unreadCount);
    } catch (e) {
      throw mapError(e);
    }
  }

  @override
  Future<void> markRead(String notificationId) async {
    try {
      await _dio.post<void>(
        ApiEndpoints.notificationRead(notificationId),
        data: const <String, dynamic>{},
      );
    } catch (e) {
      throw mapError(e);
    }
  }

  @override
  Future<int> markAllRead() async {
    try {
      // Backend returns only {status, message} — no count.
      await _dio.post<dynamic>(
        ApiEndpoints.notificationsReadAll,
        data: const <String, dynamic>{},
      );
      return 0;
    } catch (e) {
      throw mapError(e);
    }
  }

  @override
  Future<Map<String, bool>> getPreferences() async {
    try {
      final res = await _dio.get<dynamic>(ApiEndpoints.notificationPreferences);
      final raw = res.data;
      final m = (raw is Map<String, dynamic> && raw.containsKey('data'))
          ? raw['data'] as Map<String, dynamic>
          : raw as Map<String, dynamic>;
      return m.map((k, v) => MapEntry(k, v as bool));
    } catch (e) {
      throw mapError(e);
    }
  }

  @override
  Future<Map<String, bool>> updatePreferences(Map<String, bool> prefs) async {
    try {
      final res = await _dio.put<dynamic>(ApiEndpoints.notificationPreferences, data: prefs);
      final raw = res.data;
      final m = (raw is Map<String, dynamic> && raw.containsKey('data'))
          ? raw['data'] as Map<String, dynamic>
          : raw as Map<String, dynamic>;
      return m.map((k, v) => MapEntry(k, v as bool));
    } catch (e) {
      throw mapError(e);
    }
  }
}
