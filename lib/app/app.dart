import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/core/notifications/push_notification_service.dart';
import 'package:cardibee_flutter/core/routing/app_router.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
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
    });
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
    ref.read(unreadCountProvider.notifier).refresh();
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
