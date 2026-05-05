import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/theme/app_colors.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      // Navigate to home; the router redirect redirects to onboarding/auth
      // automatically if the user isn't onboarded or authenticated yet.
      if (mounted) context.go(AppRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).tokens;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: tokens.gradientHero),
        child: Stack(
          children: [
            // Decorative blobs
            Positioned(
              right: -80,
              top: -80,
              child: _Blob(color: AppColors.beeYellow.withOpacity(0.25), size: 280),
            ),
            Positioned(
              left: -80,
              bottom: -80,
              child: _Blob(color: AppColors.beeYellow.withOpacity(0.15), size: 280),
            ),
            // Centre content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo card
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: tokens.brXl,
                      boxShadow: tokens.shadowGlow,
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/cardibee_logo.png',
                      width: 72,
                      height: 72,
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.7, 0.7),
                        end: const Offset(1, 1),
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 300.ms)
                      .then()
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(begin: 0, end: -8, duration: 2000.ms, curve: Curves.easeInOut),

                  const SizedBox(height: 20),

                  // Wordmark
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: AppFonts.display,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      children: [
                        const TextSpan(text: 'Cardi'),
                        TextSpan(
                          text: 'Bee',
                          style: TextStyle(color: AppColors.beeYellow),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                  const SizedBox(height: 8),

                  // Tagline — canonical: "Scout. Compare. Save."
                  Text(
                    'Scout · Compare · Save',
                    style: TextStyle(
                      fontFamily: AppFonts.sans,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 3,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                ],
              ),
            ),
            // Footer
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text(
                  'CARD OFFERS · ANY BRAND · ANYTIME',
                  style: TextStyle(
                    fontFamily: AppFonts.sans,
                    fontSize: 9,
                    letterSpacing: 2.5,
                    color: Colors.white.withOpacity(0.35),
                  ),
                ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
    child: const SizedBox.shrink(),
  );
}
