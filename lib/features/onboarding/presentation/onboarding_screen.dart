import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/theme/app_colors.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/theme/app_typography.dart';

class _Slide {
  const _Slide({required this.icon, required this.title, required this.titleBn, required this.body, required this.bodyBn, required this.gradientColors});
  final IconData icon;
  final String title;
  final String titleBn;
  final String body;
  final String bodyBn;
  final List<Color> gradientColors;
}

const _slides = [
  _Slide(
    icon: Icons.credit_card_rounded,
    title: 'Add your cards',
    titleBn: 'আপনার কার্ড যোগ করুন',
    body: 'Save the credit & debit cards you carry. We never ask for card numbers — just bank, network and type.',
    bodyBn: 'আপনার ক্রেডিট ও ডেবিট কার্ড সেভ করুন। আমরা কখনো কার্ড নম্বর চাই না — শুধু ব্যাংক, নেটওয়ার্ক ও ধরন।',
    gradientColors: AppColors.gradientNavy,
  ),
  _Slide(
    icon: Icons.search_rounded,
    title: 'See every offer',
    titleBn: 'সব অফার দেখুন',
    body: 'Discover discounts, cashback and BOGO deals across food, travel, shopping and more — all matched to your wallet.',
    bodyBn: 'খাবার, ভ্রমণ, কেনাকাটা সহ সব ধরনের ছাড়, ক্যাশব্যাক ও বিশেষ অফার আপনার কার্ড অনুযায়ী খুঁজে পান।',
    gradientColors: [Color(0xFF0D3B2B), Color(0xFF1A5C42)],
  ),
  _Slide(
    icon: Icons.notifications_active_rounded,
    title: 'Never miss a deal',
    titleBn: 'কোনো ডিল মিস করবেন না',
    body: 'Get alerted when offers are about to expire and always pick the card that gives you the best value.',
    bodyBn: 'অফার শেষ হওয়ার আগেই সতর্কতা পান এবং সব সময় সেরা মূল্যের কার্ড বেছে নিন।',
    gradientColors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _index = 0;

  void _next() {
    if (_index < _slides.length - 1) {
      setState(() => _index++);
    } else {
      context.go(AppRoutes.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;
    final slide  = _slides[_index];

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.s20, vertical: tokens.s8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/cardibee-mark.webp', width: 28, height: 28),
                      const SizedBox(width: 8),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontFamily: AppFonts.display, fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface),
                          children: [
                            const TextSpan(text: 'Cardi'),
                            TextSpan(text: 'Bee', style: TextStyle(color: cs.tertiary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.auth),
                    child: Text('Skip', style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurfaceVariant)),
                  ),
                ],
              ),
            ),

            // Slide illustration
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.s24),
                child: AnimatedSwitcher(
                  duration: 350.ms,
                  transitionBuilder: (child, anim) => SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(anim),
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: _SlideContent(slide: slide, key: ValueKey(_index)),
                ),
              ),
            ),

            // Dots + button
            Padding(
              padding: EdgeInsets.fromLTRB(tokens.s24, 0, tokens.s24, tokens.s32),
              child: Column(
                children: [
                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (i) {
                      final active = i == _index;
                      return GestureDetector(
                        onTap: () => setState(() => _index = i),
                        child: AnimatedContainer(
                          duration: 200.ms,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: active ? 28 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: active ? cs.primary : cs.outlineVariant,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: tokens.s24),
                  ElevatedButton(
                    onPressed: _next,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_index < _slides.length - 1 ? 'Next' : 'Get started'),
                        const SizedBox(width: 6),
                        const Icon(Icons.chevron_right_rounded, size: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: tokens.s16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?', style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                      TextButton(
                        onPressed: () => context.go('${AppRoutes.auth}?mode=login'),
                        child: const Text('Log in'),
                      ),
                    ],
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

class _SlideContent extends StatelessWidget {
  const _SlideContent({required this.slide, super.key});
  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: tokens.s16),
        // Illustration box
        Container(
          height: 260,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: slide.gradientColors,
            ),
            borderRadius: tokens.brXl,
          ),
          child: Icon(slide.icon, size: 96, color: Colors.white),
        ),
        SizedBox(height: tokens.s32),
        Text(slide.title, style: theme.textTheme.headlineLarge),
        SizedBox(height: tokens.s12),
        Text(
          slide.body,
          style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant, height: 1.6),
        ),
      ],
    );
  }
}
