import 'package:flutter/material.dart';

// All hex values derived from the source design system (index.css).
// Light-mode values are the canonical source; dark-mode values defined
// in AppTheme.darkColorScheme.
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color navyDeep   = Color(0xFF0B1437); // primary (light)
  static const Color navySoft   = Color(0xFF1A2456); // primary-soft
  static const Color navyMid    = Color(0xFF2B3870); // gradient end

  static const Color beeYellow  = Color(0xFFF4B400); // accent / primary (dark)
  static const Color beeYellowBright = Color(0xFFF4C84A); // gradient start
  static const Color beeYellowDeep   = Color(0xFFF08C00); // gradient end
  static const Color beeYellowSoft   = Color(0xFFFFF5CC); // accent-soft

  // ── Semantic ────────────────────────────────────────────────────────────────
  static const Color success    = Color(0xFF277A50);
  static const Color successFg  = Color(0xFFFFFFFF);
  static const Color warning    = Color(0xFFF46B10);
  static const Color warningFg  = Color(0xFFFFFFFF);
  static const Color error      = Color(0xFFE53935);
  static const Color errorFg    = Color(0xFFFFFFFF);

  // ── Light palette ───────────────────────────────────────────────────────────
  static const Color backgroundLight    = Color(0xFFFAF9F5);
  static const Color surfaceLight       = Color(0xFFFFFFFF);
  static const Color foregroundLight    = Color(0xFF0D1233);
  static const Color secondaryLight     = Color(0xFFEFF1FA);
  static const Color mutedLight         = Color(0xFFEFF0F7);
  static const Color mutedFgLight       = Color(0xFF676C8A);
  static const Color borderLight        = Color(0xFFE2E4EF);

  // ── Dark palette ────────────────────────────────────────────────────────────
  static const Color backgroundDark     = Color(0xFF0C0F1C);
  static const Color surfaceDark        = Color(0xFF131828);
  static const Color foregroundDark     = Color(0xFFF5F3EC);
  static const Color secondaryDark      = Color(0xFF1C2235);
  static const Color mutedDark          = Color(0xFF1A1F36);
  static const Color mutedFgDark        = Color(0xFF8B91B0);
  static const Color borderDark         = Color(0xFF252C43);

  // ── Card gradients ──────────────────────────────────────────────────────────
  static const List<Color> gradientNavy      = [Color(0xFF0B1437), Color(0xFF1A2456)];
  static const List<Color> gradientEmerald   = [Color(0xFF0D3B2B), Color(0xFF1A5C42)];
  static const List<Color> gradientBurgundy  = [Color(0xFF3B1020), Color(0xFF5C1F35)];
  static const List<Color> gradientGraphite  = [Color(0xFF252C3D), Color(0xFF38404F)];

  // Hero background gradient
  static const List<Color> gradientHero = [
    Color(0xFF0B1437),
    Color(0xFF1A2456),
    Color(0xFF2B3870),
  ];

  // Accent (gold) gradient
  static const List<Color> gradientAccent = [
    Color(0xFFF4C84A),
    Color(0xFFF08C00),
  ];

  // Category banner gradients (merchant-specific, matches source bannerHue)
  static const Map<String, List<Color>> offerBanners = {
    'food_sultans':      [Color(0xFFF97316), Color(0xFFE11D48)],
    'shopping_aarong':   [Color(0xFFDC2626), Color(0xFFF59E0B)],
    'travel_usbangla':   [Color(0xFF2563EB), Color(0xFF4338CA)],
    'groceries_meena':   [Color(0xFF059669), Color(0xFF0D9488)],
    'entertainment_star':[Color(0xFF7C3AED), Color(0xFFC026D3)],
    'health_apollo':     [Color(0xFF0891B2), Color(0xFF1D4ED8)],
    'food_foodpanda':    [Color(0xFFEC4899), Color(0xFFE11D48)],
    'shopping_daraz':    [Color(0xFFF59E0B), Color(0xFFEA580C)],
    'travel_westin':     [Color(0xFF475569), Color(0xFF18181B)],
  };

  // Mastercard logo colours
  static const Color mastercardRed    = Color(0xFFEB001B);
  static const Color mastercardYellow = Color(0xFFF79E1B);

  // Amex logo colour
  static const Color amexBlue = Color(0xFF006FCF);
}
