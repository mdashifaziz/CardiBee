import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/widgets/skeleton.dart';
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
      ref.read(unreadCountProvider.notifier).set(result.unreadCount);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _markAllRead() async {
    await ref.read(notificationsRepositoryProvider).markAllRead();
    setState(() {
      for (final n in _items) { n['is_read'] = true; n['read'] = true; }
      _unreadCount = 0;
    });
    ref.read(unreadCountProvider.notifier).clear();
  }

  // Tolerant read check — live API uses `is_read`, the mock uses `read`.
  bool _isUnread(Map<String, dynamic> n) =>
      (n['is_read'] ?? n['read'] ?? true) == false;

  Future<void> _markRead(String id) async {
    await ref.read(notificationsRepositoryProvider).markRead(id);
    setState(() {
      for (final n in _items) {
        if ('${n['id']}' == id) { n['is_read'] = true; n['read'] = true; }
      }
      _unreadCount = _items.where(_isUnread).length;
    });
    ref.read(unreadCountProvider.notifier).set(_unreadCount);
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
          ? ListView.separated(
              padding: EdgeInsets.symmetric(
                  horizontal: tokens.s16, vertical: tokens.s12),
              itemCount: 6,
              separatorBuilder: (_, __) => SizedBox(height: tokens.s8),
              itemBuilder: (_, __) => Padding(
                padding: EdgeInsets.symmetric(vertical: tokens.s8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonCircle(size: 40),
                    SizedBox(width: tokens.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SkeletonLine(height: 14),
                          SizedBox(height: tokens.s6),
                          const SkeletonLine(width: 220, height: 10),
                          SizedBox(height: tokens.s6),
                          const SkeletonLine(width: 80, height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
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
                      final n = _items[i];
                      _markRead('${n['id']}');
                      final offerId = n['offer_id'] as String?;
                      final target = AppRoutes.resolveLink(n['link_url'] as String?)
                          ?? (offerId != null
                              ? AppRoutes.offerDetailPath(offerId)
                              : null);
                      if (target != null && context.mounted) {
                        context.push(target);
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
    final isRead  = (notif['is_read'] ?? notif['read'] ?? true) == true;
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
