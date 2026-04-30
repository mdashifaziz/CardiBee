import 'package:flutter/material.dart';

// Font families matching the source (DM Sans body, Space Grotesk display).
abstract final class AppFonts {
  static const String sans    = 'DMSans';
  static const String display = 'SpaceGrotesk';
  static const String mono    = 'monospace';
}

// Base text theme — colours are intentionally unset here; AppTheme applies
// them via copyWith so they respond to light/dark mode correctly.
abstract final class AppTypography {
  static TextTheme get textTheme => const TextTheme(
    // Display / headline (Space Grotesk)
    displayLarge:  TextStyle(fontFamily: AppFonts.display, fontSize: 40, fontWeight: FontWeight.w700, letterSpacing: -0.5),
    displayMedium: TextStyle(fontFamily: AppFonts.display, fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5),
    displaySmall:  TextStyle(fontFamily: AppFonts.display, fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5),

    headlineLarge:  TextStyle(fontFamily: AppFonts.display, fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.3),
    headlineMedium: TextStyle(fontFamily: AppFonts.display, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.3),
    headlineSmall:  TextStyle(fontFamily: AppFonts.display, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.2),

    titleLarge:  TextStyle(fontFamily: AppFonts.display, fontSize: 16, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontFamily: AppFonts.display, fontSize: 14, fontWeight: FontWeight.w600),
    titleSmall:  TextStyle(fontFamily: AppFonts.display, fontSize: 13, fontWeight: FontWeight.w600),

    // Body (DM Sans)
    bodyLarge:  TextStyle(fontFamily: AppFonts.sans, fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
    bodyMedium: TextStyle(fontFamily: AppFonts.sans, fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
    bodySmall:  TextStyle(fontFamily: AppFonts.sans, fontSize: 12, fontWeight: FontWeight.w400, height: 1.4),

    // Label / caption
    labelLarge:  TextStyle(fontFamily: AppFonts.sans, fontSize: 13, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontFamily: AppFonts.sans, fontSize: 11, fontWeight: FontWeight.w600),
    labelSmall:  TextStyle(fontFamily: AppFonts.sans, fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 0.5),
  );
}
