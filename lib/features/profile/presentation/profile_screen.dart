import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/storage/token_storage.dart';
import 'package:cardibee_flutter/core/theme/app_colors.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/theme/app_typography.dart';
import 'package:cardibee_flutter/core/theme/theme_provider.dart';
import 'package:cardibee_flutter/features/auth/providers/auth_provider.dart';
import 'package:cardibee_flutter/features/cards/providers/cards_notifier.dart';
import 'package:cardibee_flutter/features/offers/providers/offers_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme    = Theme.of(context);
    final cs       = theme.colorScheme;
    final tokens   = theme.tokens;
    final user     = ref.watch(currentUserProvider);
    final themeMode= ref.watch(themeProvider);
    final isDark   = themeMode == ThemeMode.dark;
    final cards    = ref.watch(cardsNotifierProvider).valueOrNull ?? [];

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: tokens.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(tokens.s20, tokens.s8, tokens.s20, 0),
                child: Text('Profile', style: theme.textTheme.headlineLarge),
              ),
              SizedBox(height: tokens.s16),

              // ── Hero card ─────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.s20),
                child: Container(
                  padding: EdgeInsets.all(tokens.s20),
                  decoration: BoxDecoration(
                    gradient: tokens.gradientHero,
                    borderRadius: tokens.brXl,
                    boxShadow: tokens.shadowLg,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.beeYellow,
                              borderRadius: tokens.brLg,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              user?.initials ?? '?',
                              style: TextStyle(
                                fontFamily: AppFonts.display,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navyDeep,
                              ),
                            ),
                          ),
                          SizedBox(width: tokens.s16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.fullName ?? 'CardiBee User',
                                style: const TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                user?.phone ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: tokens.s20),
                      Divider(color: Colors.white.withOpacity(0.1)),
                      SizedBox(height: tokens.s16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatCol(
                            value: '${cards.length}',
                            label: 'Cards',
                          ),
                          _StatCol(
                            value: '—',
                            label: 'Saved',
                          ),
                          _StatCol(
                            value: '৳${_fmt(user?.savingsYtdBdt ?? 0)}',
                            label: 'Saved YTD',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: tokens.s16),

              // ── Dark mode toggle ──────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.s20),
                child: GestureDetector(
                  onTap: () => ref.read(themeProvider.notifier).toggle(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: tokens.s16, vertical: tokens.s12),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLowest,
                      borderRadius: tokens.brLg,
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: cs.tertiary.withOpacity(0.15),
                            borderRadius: tokens.brMd,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            isDark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            size: 18, color: cs.tertiary,
                          ),
                        ),
                        SizedBox(width: tokens.s12),
                        Expanded(
                          child: Text(
                            isDark ? 'Light mode' : 'Dark mode',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          isDark ? 'On' : 'Off',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: tokens.s12),

              // ── Settings menu ─────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.s20),
                child: Container(
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLowest,
                    borderRadius: tokens.brLg,
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Builder(builder: (context) {
                    final items = _menuItems(context, ref, cards.length);
                    return Column(
                      children: List.generate(items.length, (i) {
                        final item = items[i];
                        return _MenuItem(
                          icon:    item.$1,
                          label:   item.$2,
                          badge:   item.$3,
                          onTap:   item.$4,
                          divider: i < items.length - 1,
                        );
                      }),
                    );
                  }),
                ),
              ),

              SizedBox(height: tokens.s12),

              // ── Logout ────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.s20),
                child: GestureDetector(
                  onTap: () => _logout(context, ref),
                  child: Container(
                    padding: EdgeInsets.all(tokens.s16),
                    decoration: BoxDecoration(
                      color: cs.errorContainer.withOpacity(0.3),
                      borderRadius: tokens.brLg,
                      border: Border.all(
                          color: cs.error.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded,
                            size: 18, color: cs.error),
                        SizedBox(width: tokens.s8),
                        Text(
                          'Log out',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cs.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: tokens.s24),

              // Version
              Center(
                child: Text(
                  'CardiBee v1.0 · Made in 🇧🇩',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<(IconData, String, String?, VoidCallback?)> _menuItems(
    BuildContext context,
    WidgetRef ref,
    int cardCount,
  ) => [
    (Icons.credit_card_rounded,       'My cards',           '$cardCount', () => context.go(AppRoutes.cards)),
    (Icons.favorite_border_rounded,   'Favorites',          null,         () => context.push(AppRoutes.favorites)),
    (Icons.notifications_outlined,    'Notifications',      null,         () => context.push(AppRoutes.notifications)),
    (Icons.shield_outlined,           'Privacy & security', null,         null),
    (Icons.description_outlined,      'Terms of service',   null,         null),
    (Icons.info_outline_rounded,      'About CardiBee',     null,         null),
  ];

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(tokenStorageProvider).clearTokens();
    ref.read(currentUserProvider.notifier).state = null;
    if (context.mounted) context.go(AppRoutes.auth);
  }

  static String _fmt(int v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}k';
    return v.toString();
  }
}

class _StatCol extends StatelessWidget {
  const _StatCol({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: Colors.white.withOpacity(0.6),
        ),
      ),
    ],
  );
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.divider,
    this.badge,
  });
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback? onTap;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: tokens.s16, vertical: tokens.s12),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: tokens.brMd,
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 18, color: cs.onSurface),
                ),
                SizedBox(width: tokens.s12),
                Expanded(
                  child: Text(label, style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500)),
                ),
                if (badge != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: cs.tertiary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badge!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: cs.tertiary,
                      ),
                    ),
                  ),
                  SizedBox(width: tokens.s8),
                ],
                Icon(Icons.chevron_right_rounded,
                    size: 18, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        ),
        if (divider) Divider(height: 1, color: cs.outlineVariant),
      ],
    );
  }
}
