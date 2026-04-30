import 'package:flutter/material.dart';
import 'package:cardibee_flutter/core/theme/app_colors.dart';

// Design tokens extension on ThemeData so screens read tokens,
// not magic numbers.  Access via: Theme.of(context).tokens
extension CardiBeeTokensX on ThemeData {
  CardiBeeTokens get tokens => _tokens;
}

// Single static instance — values never change at runtime.
const CardiBeeTokens _tokens = CardiBeeTokens._();

final class CardiBeeTokens {
  const CardiBeeTokens._();

  // ── Spacing (8-unit base) ──────────────────────────────────────────────────
  double get s2  =>  2;
  double get s4  =>  4;
  double get s6  =>  6;
  double get s8  =>  8;
  double get s10 => 10;
  double get s12 => 12;
  double get s16 => 16;
  double get s20 => 20;
  double get s24 => 24;
  double get s28 => 28;
  double get s32 => 32;
  double get s40 => 40;
  double get s48 => 48;
  double get s56 => 56;
  double get s64 => 64;

  // ── Border radii ───────────────────────────────────────────────────────────
  double get radiusSm   => 8;
  double get radiusMd   => 12;   // rounded-xl
  double get radiusLg   => 16;   // rounded-2xl — default interactive
  double get radiusXl   => 24;   // rounded-3xl — hero cards
  double get radiusFull => 999;  // rounded-full — chips, badges

  BorderRadius get brSm   => BorderRadius.circular(radiusSm);
  BorderRadius get brMd   => BorderRadius.circular(radiusMd);
  BorderRadius get brLg   => BorderRadius.circular(radiusLg);
  BorderRadius get brXl   => BorderRadius.circular(radiusXl);
  BorderRadius get brFull => BorderRadius.circular(radiusFull);

  // ── Shadows ────────────────────────────────────────────────────────────────
  List<BoxShadow> get shadowSm => const [
    BoxShadow(blurRadius: 2, offset: Offset(0, 1), color: Color(0x0F182040)),
  ];
  List<BoxShadow> get shadowMd => const [
    BoxShadow(blurRadius: 20, offset: Offset(0, 6), spreadRadius: -8, color: Color(0x1E182040)),
  ];
  List<BoxShadow> get shadowLg => const [
    BoxShadow(blurRadius: 40, offset: Offset(0, 20), spreadRadius: -16, color: Color(0x2E182040)),
  ];
  List<BoxShadow> get shadowGlow => const [
    BoxShadow(blurRadius: 32, offset: Offset(0, 12), spreadRadius: -12, color: Color(0x72F4B400)),
  ];

  // ── Gradients ──────────────────────────────────────────────────────────────
  LinearGradient get gradientHero => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.gradientHero,
    stops: [0.0, 0.6, 1.0],
  );

  LinearGradient get gradientAccent => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.gradientAccent,
  );

  LinearGradient cardGradient(String gradientKey) {
    final colors = _cardGradients[gradientKey] ?? AppColors.gradientNavy;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  LinearGradient offerBanner(String offerBannerKey) {
    final colors = AppColors.offerBanners[offerBannerKey]
        ?? [AppColors.navyDeep, AppColors.navySoft];
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  static const Map<String, List<Color>> _cardGradients = {
    'navy':     AppColors.gradientNavy,
    'emerald':  AppColors.gradientEmerald,
    'burgundy': AppColors.gradientBurgundy,
    'graphite': AppColors.gradientGraphite,
  };

  // ── Transitions ────────────────────────────────────────────────────────────
  Duration get durationFast   => const Duration(milliseconds: 200);
  Duration get durationNormal => const Duration(milliseconds: 300);
  Duration get durationSpring => const Duration(milliseconds: 400);

  Curve get curveBase   => Curves.easeInOut;
  Curve get curveSpring => Curves.elasticOut;

  // ── Bottom nav height (for SafeArea padding calculations) ─────────────────
  double get bottomNavHeight => 64;
}
