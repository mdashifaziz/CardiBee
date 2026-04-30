import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/features/notifications/providers/notifications_provider.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  List<Map<String, dynamic>> _items = [];
  int _unreadCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final result = await ref.read(notificationsRepositoryProvider).listNotifications();
      setState(() {
        _items       = result.items.cast<Map<String, dynamic>>();
        _unreadCount = result.unreadCount;
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _markAllRead() async {
    await ref.read(notificationsRepositoryProvider).markAllRead();
    setState(() {
      for (final n in _items) n['read'] = true;
      _unreadCount = 0;
    });
  }

  Future<void> _markRead(String id) async {
    await ref.read(notificationsRepositoryProvider).markRead(id);
    setState(() {
      for (final n in _items) {
        if (n['id'] == id) n['read'] = true;
      }
      _unreadCount = _items.where((n) => n['read'] == false).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(
          _unreadCount > 0 ? 'Notifications ($_unreadCount)' : 'Notifications',
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? _EmptyNotifications()
              : ListView.separated(
                  padding: EdgeInsets.symmetric(
                      horizontal: tokens.s16, vertical: tokens.s12),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => SizedBox(height: tokens.s8),
                  itemBuilder: (_, i) => _NotifTile(
                    notif: _items[i],
                    onTap: () {
                      final id = _items[i]['id'] as String;
                      _markRead(id);
                      final offerId = _items[i]['offer_id'] as String?;
                      if (offerId != null && context.mounted) {
                        context.push(AppRoutes.offerDetailPath(offerId));
                      }
                    },
                  ),
                ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  const _NotifTile({required this.notif, required this.onTap});
  final Map<String, dynamic> notif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme   = Theme.of(context);
    final cs      = theme.colorScheme;
    final tokens  = theme.tokens;
    final isRead  = notif['read'] as bool? ?? true;
    final type    = notif['type'] as String? ?? 'system';

    Color iconColor() => switch (type) {
      'offer_expiring' => const Color(0xFFF46B10),
      'new_offer'      => const Color(0xFF277A50),
      'promotional'    => cs.tertiary,
      _                => cs.onSurfaceVariant,
    };

    IconData iconData() => switch (type) {
      'offer_expiring' => Icons.access_time_filled_rounded,
      'new_offer'      => Icons.local_offer_rounded,
      'promotional'    => Icons.campaign_rounded,
      _                => Icons.notifications_rounded,
    };

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.all(tokens.s12),
        decoration: BoxDecoration(
          color: isRead
              ? cs.surfaceContainerLowest
              : cs.primary.withOpacity(0.05),
          borderRadius: tokens.brLg,
          border: Border.all(
            color: isRead ? cs.outlineVariant : cs.primary.withOpacity(0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: iconColor().withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(iconData(), size: 18, color: iconColor()),
            ),
            SizedBox(width: tokens.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notif['title'] as String? ?? '',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                            color: cs.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: tokens.s4),
                  Text(
                    notif['body'] as String? ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_none_rounded,
              size: 56, color: cs.onSurfaceVariant),
          SizedBox(height: tokens.s16),
          Text("You're all caught up!", style: theme.textTheme.titleMedium),
          SizedBox(height: tokens.s8),
          Text(
            'New offer alerts and reminders will appear here.',
            style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
