import 'package:flutter/material.dart';
import 'package:cardibee_flutter/core/theme/app_colors.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('About CardiBee'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(tokens.s20, tokens.s16, tokens.s20, tokens.s40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand hero
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: tokens.s20, vertical: tokens.s28),
              decoration: BoxDecoration(
                gradient: tokens.gradientHero,
                borderRadius: tokens.brXl,
                boxShadow: tokens.shadowLg,
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.beeYellow,
                      borderRadius: tokens.brXl,
                      boxShadow: tokens.shadowGlow,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '🐝',
                      style: TextStyle(fontSize: 36),
                    ),
                  ),
                  SizedBox(height: tokens.s16),
                  const Text(
                    'CardiBee',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: tokens.s6),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: tokens.s4),
                  Text(
                    'Made with ❤️ in 🇧🇩 Bangladesh',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: tokens.s24),

            // Mission
            _InfoCard(
              icon: Icons.lightbulb_outline_rounded,
              title: 'Our Mission',
              body:
                  'CardiBee helps you get the most from your credit cards. We surface '
                  'the best offers, discounts, and cashback deals so you never miss a '
                  'saving — all in one place.',
            ),

            SizedBox(height: tokens.s12),

            // What we do
            _InfoCard(
              icon: Icons.auto_awesome_outlined,
              title: 'What We Do',
              body:
                  'We aggregate credit-card offers from banks and merchants across '
                  'Bangladesh. Add your cards, and CardiBee instantly shows which '
                  'offers you\'re eligible for, ranks the best deals, and lets you '
                  'compare cards side by side.',
            ),

            SizedBox(height: tokens.s24),

            // Stats row
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: tokens.s16, vertical: tokens.s20),
              decoration: BoxDecoration(
                gradient: tokens.gradientHero,
                borderRadius: tokens.brLg,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _StatBadge(value: '20+', label: 'Banks'),
                  _Divider(),
                  _StatBadge(value: '100+', label: 'Offers'),
                  _Divider(),
                  _StatBadge(value: '50+', label: 'Merchants'),
                ],
              ),
            ),

            SizedBox(height: tokens.s24),

            // Links section
            Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerLowest,
                borderRadius: tokens.brLg,
                border: Border.all(color: cs.outlineVariant),
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  _LinkRow(
                    icon: Icons.language_outlined,
                    label: 'Website',
                    value: 'cardibee.app',
                    divider: true,
                  ),
                  _LinkRow(
                    icon: Icons.mail_outline_rounded,
                    label: 'Support',
                    value: 'support@cardibee.app',
                    divider: true,
                  ),
                  _LinkRow(
                    icon: Icons.share_outlined,
                    label: 'Follow us',
                    value: '@cardibee',
                    divider: false,
                  ),
                ],
              ),
            ),

            SizedBox(height: tokens.s24),

            Center(
              child: Text(
                '© 2025 CardiBee · All rights reserved',
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: cs.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Container(
      padding: EdgeInsets.all(tokens.s16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: tokens.brLg,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: tokens.brMd,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: cs.onSurface),
          ),
          SizedBox(width: tokens.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                SizedBox(height: tokens.s6),
                Text(
                  body,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      );
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 40,
        color: Colors.white.withOpacity(0.15),
      );
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.divider,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: tokens.s16, vertical: tokens.s12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLow,
                  borderRadius: tokens.brMd,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 18, color: cs.onSurface),
              ),
              SizedBox(width: tokens.s12),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: cs.onSurfaceVariant),
              ),
              SizedBox(width: tokens.s4),
              Icon(Icons.chevron_right_rounded,
                  size: 18, color: cs.onSurfaceVariant),
            ],
          ),
        ),
        if (divider) Divider(height: 1, color: cs.outlineVariant),
      ],
    );
  }
}
