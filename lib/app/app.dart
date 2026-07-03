import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/core/notifications/push_notification_service.dart';
import 'package:cardibee_flutter/core/routing/app_router.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/storage/token_storage.dart';
import 'package:cardibee_flutter/core/theme/app_theme.dart';
import 'package:cardibee_flutter/core/theme/theme_provider.dart';
import 'package:cardibee_flutter/features/notifications/providers/notifications_provider.dart';
import 'package:cardibee_flutter/gen/app_localizations.dart';

class CardiBeeApp extends ConsumerStatefulWidget {
  const CardiBeeApp({super.key});

  @override
  ConsumerState<CardiBeeApp> createState() => _CardiBeeAppState();
}

class _CardiBeeAppState extends ConsumerState<CardiBeeApp> {
  @override
  void initState() {
    super.initState();
    // Wire push callbacks once the widget tree (and router) exists.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final push = PushNotificationService.instance;
      // Foreground push → refresh the unread badge.
      push.onForegroundMessage = (_) =>
          ref.read(unreadCountProvider.notifier).refresh();
      // Tap (background / terminated / cold start) → deep-link.
      push.setTapHandler(_handleTap);
      // Keep the backend's token registration fresh: re-register on every
      // app start and whenever FCM rotates the token. Login/signup also
      // register, but a reinstall while a session survives would otherwise
      // leave the backend holding a dead token.
      push.onTokenRefreshed = (_) => _registerDeviceToken();
      _registerDeviceToken();
    });
  }

  /// Idempotent server-side (update_or_create on token) — but needs a JWT,
  /// so skip when no session exists yet; login/signup register instead.
  Future<void> _registerDeviceToken() async {
    try {
      final hasSession = await ref.read(tokenStorageProvider).hasTokens();
      if (!hasSession) return;
      final token = await PushNotificationService.instance.ensureToken();
      if (token == null) return;
      await ref.read(notificationsRepositoryProvider).registerDevice(token);
    } catch (_) {
      // Non-fatal — the next start / login re-registers.
    }
  }

  void _handleTap(RemoteMessage message) {
    if (!mounted) return;
    final router  = ref.read(routerProvider);
    final data    = message.data;
    final offerId = data['offer_id'] as String?;
    final target  = AppRoutes.resolveLink(data['link_url'] as String?)
        ?? (offerId != null && offerId.isNotEmpty
            ? AppRoutes.offerDetailPath(offerId)
            : AppRoutes.notifications);
    router.push(target);
    _markTappedRead(data);
  }

  /// Marks the tapped notification read on the server, then refreshes the
  /// badge. Uses `recipient_id` (the per-user recipient-row id the read
  /// endpoint expects) — `notification_id` is the campaign id and must NOT
  /// be sent to markRead. All FCM data values arrive as strings.
  Future<void> _markTappedRead(Map<String, dynamic> data) async {
    final recipientId = int.tryParse(data['recipient_id']?.toString() ?? '');
    if (recipientId != null) {
      try {
        await ref
            .read(notificationsRepositoryProvider)
            .markRead('$recipientId');
      } catch (_) {
        // Non-fatal — the notifications screen can still mark it read.
      }
    }
    if (mounted) ref.read(unreadCountProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final router    = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'CardiBee',
      debugShowCheckedModeBanner: false,
      theme:      AppTheme.light,
      darkTheme:  AppTheme.dark,
      themeMode:  themeMode,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales:       AppLocalizations.supportedLocales,
    );
  }
}
