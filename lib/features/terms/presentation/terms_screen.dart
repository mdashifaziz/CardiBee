import 'package:flutter/material.dart';
import 'package:cardibee_flutter/core/theme/app_colors.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Terms of Service'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(tokens.s20, tokens.s16, tokens.s20, tokens.s40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(tokens.s20),
              decoration: BoxDecoration(
                gradient: tokens.gradientHero,
                borderRadius: tokens.brXl,
                boxShadow: tokens.shadowMd,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.beeYellow,
                      borderRadius: tokens.brLg,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.description_outlined,
                      size: 24,
                      color: AppColors.navyDeep,
                    ),
                  ),
                  SizedBox(width: tokens.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Terms of Service',
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: tokens.s4),
                        Text(
                          'Last updated: May 2025',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: tokens.s24),

            _TermsSection(
              icon: Icons.handshake_outlined,
              title: '1. Acceptance of Terms',
              body:
                  'By downloading or using CardiBee, you agree to be bound by these '
                  'Terms of Service. If you do not agree, please do not use the app.',
            ),
            _TermsSection(
              icon: Icons.manage_accounts_outlined,
              title: '2. Your Account',
              body:
                  'You are responsible for maintaining the confidentiality of your '
                  'account credentials and for all activities that occur under your '
                  'account. Notify us immediately of any unauthorised use.',
            ),
            _TermsSection(
              icon: Icons.credit_card_outlined,
              title: '3. Card & Offer Data',
              body:
                  'CardiBee aggregates credit-card offer information for informational '
                  'purposes only. Offers are subject to change by the issuing banks '
                  'without notice. Always verify current terms with your bank.',
            ),
            _TermsSection(
              icon: Icons.privacy_tip_outlined,
              title: '4. Privacy',
              body:
                  'Your privacy matters to us. We collect only the data necessary to '
                  'provide the service. We do not sell your personal information to '
                  'third parties. Please review our Privacy Policy for full details.',
            ),
            _TermsSection(
              icon: Icons.block_outlined,
              title: '5. Prohibited Use',
              body:
                  'You may not use CardiBee to engage in any unlawful activity, '
                  'attempt to reverse-engineer the app, or scrape offer data in bulk. '
                  'Violation may result in immediate account termination.',
            ),
            _TermsSection(
              icon: Icons.update_outlined,
              title: '6. Changes to Terms',
              body:
                  'We may update these terms from time to time. Continued use of '
                  'CardiBee after changes constitutes your acceptance of the new terms.',
            ),
            _TermsSection(
              icon: Icons.gavel_outlined,
              title: '7. Governing Law',
              body:
                  'These terms are governed by the laws of the People\'s Republic of '
                  'Bangladesh. Any disputes shall be resolved in the courts of Dhaka.',
              isLast: true,
            ),

            SizedBox(height: tokens.s24),

            // Footer note
            Container(
              padding: EdgeInsets.all(tokens.s16),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLowest,
                borderRadius: tokens.brLg,
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(Icons.mail_outline_rounded, size: 16, color: cs.onSurfaceVariant),
                  SizedBox(width: tokens.s8),
                  Expanded(
                    child: Text(
                      'Questions? Contact us at support@cardibee.app',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
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

class _TermsSection extends StatelessWidget {
  const _TermsSection({
    required this.icon,
    required this.title,
    required this.body,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Column(
      children: [
        Container(
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
                    Text(
                      title,
                      style: theme.textTheme.titleSmall,
                    ),
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
        ),
        if (!isLast) SizedBox(height: tokens.s8),
      ],
    );
  }
}
