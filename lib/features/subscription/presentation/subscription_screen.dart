import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/core/theme/app_colors.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/theme/app_typography.dart';
import 'package:cardibee_flutter/features/auth/providers/auth_provider.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;
    final user   = ref.watch(currentUserProvider);
    final isPro  = user?.subscription.isPro ?? false;

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          // ── Hero header ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(gradient: tokens.gradientHero),
              padding: EdgeInsets.fromLTRB(
                tokens.s20,
                MediaQuery.of(context).padding.top + tokens.s8,
                tokens.s20,
                tokens.s32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                      ),
                      SizedBox(width: tokens.s4),
                      Text(
                        'Plans',
                        style: theme.textTheme.headlineLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: tokens.s24),
                  const Icon(
                    Icons.workspace_premium_rounded,
                    size: 48,
                    color: AppColors.beeYellow,
                  ),
                  SizedBox(height: tokens.s12),
                  Text(
                    'Unlock more with Pro',
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: tokens.s8),
                  Text(
                    'Unlimited cards, priority expiry alerts, and exclusive cashback offers.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.white.withOpacity(0.72)),
                  ),
                  if (isPro) ...[
                    SizedBox(height: tokens.s20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.beeYellow,
                        borderRadius: tokens.brFull,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded,
                              size: 14, color: AppColors.navyDeep),
                          SizedBox(width: 6),
                          Text(
                            "You're on Pro",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navyDeep,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── Plans ────────────────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.all(tokens.s20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _PlanCard(
                  title: 'Free',
                  price: '৳0',
                  period: 'forever',
                  isCurrentPlan: !isPro,
                  isPro: false,
                  features: const [
                    (true,  'Up to 3 cards'),
                    (true,  'Browse all offers'),
                    (true,  'Basic notifications'),
                    (false, 'Unlimited cards'),
                    (false, 'Priority expiry alerts'),
                    (false, 'Cashback-only filter'),
                    (false, 'Card comparison tool'),
                    (false, 'Best card suggestions'),
                  ],
                ),
                SizedBox(height: tokens.s16),
                _PlanCard(
                  title: 'Pro',
                  price: '৳199',
                  period: 'per month',
                  isCurrentPlan: isPro,
                  isPro: true,
                  features: const [
                    (true, 'Unlimited cards'),
                    (true, 'Browse all offers'),
                    (true, 'Priority expiry alerts'),
                    (true, 'Cashback-only filter'),
                    (true, 'Card comparison tool'),
                    (true, 'Best card suggestions'),
                    (true, 'Early access to new offers'),
                  ],
                  ctaLabel: isPro ? null : 'Upgrade to Pro — ৳199/mo',
                ),
                SizedBox(height: tokens.s24),
                Center(
                  child: Text(
                    'Cancel anytime · No hidden fees',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
                SizedBox(height: tokens.s6),
                Center(
                  child: Text(
                    'Prices in BDT · Billed monthly',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
                SizedBox(height: tokens.s32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Plan card ──────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    required this.isCurrentPlan,
    required this.isPro,
    required this.features,
    this.ctaLabel,
  });

  final String title;
  final String price;
  final String period;
  final bool isCurrentPlan;
  final bool isPro;
  final List<(bool, String)> features;
  final String? ctaLabel;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: tokens.brXl,
        border: Border.all(
          color: isPro
              ? AppColors.beeYellow.withOpacity(0.5)
              : cs.outlineVariant,
          width: isPro ? 1.5 : 1,
        ),
        boxShadow: isPro ? tokens.shadowMd : tokens.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(tokens.s20),
            decoration: BoxDecoration(
              gradient: isPro ? tokens.gradientHero : null,
              color: isPro ? null : cs.surfaceContainerLow,
              borderRadius: BorderRadius.only(
                topLeft:  Radius.circular(tokens.radiusXl),
                topRight: Radius.circular(tokens.radiusXl),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: isPro ? Colors.white : cs.onSurface,
                            ),
                          ),
                          if (isCurrentPlan) ...[
                            SizedBox(width: tokens.s8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isPro
                                    ? AppColors.beeYellow
                                    : cs.primary.withOpacity(0.15),
                                borderRadius: tokens.brFull,
                              ),
                              child: Text(
                                'Current',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isPro ? AppColors.navyDeep : cs.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: tokens.s6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            price,
                            style: TextStyle(
                              fontFamily: AppFonts.display,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: isPro ? Colors.white : cs.onSurface,
                            ),
                          ),
                          SizedBox(width: tokens.s6),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              period,
                              style: TextStyle(
                                fontSize: 12,
                                color: isPro
                                    ? Colors.white.withOpacity(0.6)
                                    : cs.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isPro)
                  const Icon(
                    Icons.workspace_premium_rounded,
                    size: 32,
                    color: AppColors.beeYellow,
                  ),
              ],
            ),
          ),

          // Feature list
          Padding(
            padding: EdgeInsets.fromLTRB(
                tokens.s20, tokens.s16, tokens.s20, tokens.s16),
            child: Column(
              children: features.map(((bool, String) f) {
                final (included, label) = f;
                return Padding(
                  padding: EdgeInsets.only(bottom: tokens.s10),
                  child: Row(
                    children: [
                      Icon(
                        included
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        size: 18,
                        color: included
                            ? AppColors.success
                            : cs.onSurfaceVariant.withOpacity(0.4),
                      ),
                      SizedBox(width: tokens.s10),
                      Text(
                        label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: included ? cs.onSurface : cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // CTA
          if (ctaLabel != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                  tokens.s20, 0, tokens.s20, tokens.s20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.beeYellow,
                    foregroundColor: AppColors.navyDeep,
                    padding: EdgeInsets.symmetric(vertical: tokens.s16),
                    shape: RoundedRectangleBorder(
                      borderRadius: tokens.brLg,
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment gateway coming soon'),
                    ),
                  ),
                  child: Text(ctaLabel!),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
