import 'package:cardibee_flutter/features/notifications/domain/notifications_repository.dart';

final class MockNotificationsRepository implements NotificationsRepository {
  final List<Map<String, dynamic>> _items = [
    {
      'id': 'notif_01NX7B9K2M3N4P5Q6R7SULTAN',
      'type': 'offer_expiring',
      'title': 'Offer expiring soon!',
      'title_bn': 'অফারটি শীঘ্রই শেষ হবে!',
      'body': "Sultan's Dine 20% off ends in 5 days. Use your EBL Platinum Visa now.",
      'body_bn': "সুলতানস ডাইনের ২০% ছাড়ের অফার ৫ দিনে শেষ হবে।",
      'offer_id': 'off_01SD9K2M3N4P5Q6R7S8T9UAB',
      'read': false,
      'created_at': '2026-04-25T08:00:00Z',
    },
    {
      'id': 'notif_02NX7FOODPANDA2M3N4P5NEW',
      'type': 'new_offer',
      'title': 'New offer for your card',
      'title_bn': 'আপনার কার্ডের জন্য নতুন অফার',
      'body': 'Foodpanda ৳200 off — your Dutch-Bangla Nexus qualifies!',
      'body_bn': 'ফুডপান্ডায় ৳২০০ ছাড় — আপনার ডাচ-বাংলা নেক্সাস কার্ডে প্রযোজ্য!',
      'offer_id': 'off_07FP3K2M3N4P5FOODPANDA7Q',
      'read': true,
      'created_at': '2026-04-22T12:00:00Z',
    },
  ];

  final Map<String, bool> _prefs = {
    'offer_expiring': true,
    'new_offer': true,
    'system': true,
    'promotional': false,
  };

  @override
  Future<({List<dynamic> items, String? nextCursor, int unreadCount})> listNotifications({
    bool unreadOnly = false,
    int limit = 20,
    String? cursor,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var list = List<dynamic>.from(_items);
    if (unreadOnly) list = list.where((n) => n['read'] == false).toList();
    final unread = _items.where((n) => n['read'] == false).length;
    return (items: list, nextCursor: null, unreadCount: unread);
  }

  @override
  Future<void> markRead(String notificationId) async {
    final idx = _items.indexWhere((n) => n['id'] == notificationId);
    if (idx != -1) _items[idx]['read'] = true;
  }

  @override
  Future<int> markAllRead() async {
    int count = 0;
    for (final n in _items) {
      if (n['read'] == false) { n['read'] = true; count++; }
    }
    return count;
  }

  @override
  Future<Map<String, bool>> getPreferences() async => Map.from(_prefs);

  @override
  Future<Map<String, bool>> updatePreferences(Map<String, bool> prefs) async {
    _prefs.addAll(prefs);
    return Map.from(_prefs);
  }
}
