import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const _BottomNav(),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  static const _items = [
    (icon: Icons.home_rounded,         activeIcon: Icons.home_rounded,             label: 'Home',      route: AppRoutes.home),
    (icon: Icons.local_offer_outlined, activeIcon: Icons.local_offer_rounded,      label: 'My Offers', route: AppRoutes.myOffers),
    (icon: Icons.explore_outlined,     activeIcon: Icons.explore_rounded,          label: 'Browse',    route: AppRoutes.browse),
    (icon: Icons.credit_card_outlined, activeIcon: Icons.credit_card_rounded,      label: 'Cards',     route: AppRoutes.cards),
    (icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded,         label: 'Profile',   route: AppRoutes.profile),
  ];

  @override
  Widget build(BuildContext context) {
    final theme    = Theme.of(context);
    final cs       = theme.colorScheme;
    final tokens   = theme.tokens;
    final location = GoRouterState.of(context).matchedLocation;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: tokens.bottomNavHeight,
          child: Row(
            children: _items.map((item) {
              final isActive = location.startsWith(item.route) &&
                  // home is exact — avoid matching /app/home for other /app/* routes
                  (item.route != AppRoutes.home || location == AppRoutes.home);

              return Expanded(
                child: Semantics(
                  label: item.label,
                  button: true,
                  selected: isActive,
                  child: InkWell(
                    onTap: () => context.go(item.route),
                    borderRadius: tokens.brMd,
                    child: AnimatedContainer(
                      duration: tokens.durationFast,
                      curve: tokens.curveBase,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: tokens.durationFast,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? cs.tertiary.withOpacity(0.15)
                                  : Colors.transparent,
                              borderRadius: tokens.brMd,
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  isActive ? item.activeIcon : item.icon,
                                  size: 22,
                                  color: isActive ? cs.primary : cs.onSurfaceVariant,
                                ),
                                if (isActive)
                                  Positioned(
                                    bottom: -6,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Container(
                                        width: 4,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: cs.tertiary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isActive ? cs.primary : cs.onSurfaceVariant,
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
