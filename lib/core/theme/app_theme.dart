import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cardibee_flutter/core/theme/app_colors.dart';
import 'package:cardibee_flutter/core/theme/app_typography.dart';

abstract final class AppTheme {
  // ── Light ───────────────────────────────────────────────────────────────────
  static ThemeData get light => _build(Brightness.light);

  // ── Dark ────────────────────────────────────────────────────────────────────
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final cs = isDark ? _darkScheme : _lightScheme;
    final textTheme = AppTypography.textTheme.apply(
      bodyColor: cs.onSurface,
      displayColor: cs.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: cs,
      textTheme: textTheme,

      // Scaffold
      scaffoldBackgroundColor: cs.surface,

      // AppBar — transparent, no elevation, no shadow
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: cs.onSurface),
        iconTheme: IconThemeData(color: cs.onSurface),
      ),

      // Cards — no elevation per flutter-skill rule
      cardTheme: CardThemeData(
        color: cs.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cs.outlineVariant),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated buttons — accent gold, rounded-2xl
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      // Outlined buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.primary,
          side: BorderSide(color: cs.outline),
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      // Text buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        labelStyle: textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: cs.surfaceContainerLow,
        selectedColor: cs.primary,
        labelStyle: AppTypography.textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: BorderSide(color: cs.outlineVariant),
        ),
        elevation: 0,
        pressElevation: 0,
      ),

      // BottomNavigationBar — handled with custom widget; suppress default
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Splash / highlight
      splashFactory: InkRipple.splashFactory,
    );
  }

  // ── Light ColorScheme ────────────────────────────────────────────────────────
  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary — deep navy
    primary:         AppColors.navyDeep,
    onPrimary:       AppColors.backgroundLight,
    primaryContainer:        AppColors.navySoft,
    onPrimaryContainer:      AppColors.backgroundLight,

    // Secondary
    secondary:        AppColors.secondaryLight,
    onSecondary:      AppColors.navyDeep,
    secondaryContainer:     AppColors.secondaryLight,
    onSecondaryContainer:   AppColors.navyDeep,

    // Tertiary — bee yellow accent
    tertiary:         AppColors.beeYellow,
    onTertiary:       AppColors.navyDeep,
    tertiaryContainer:      AppColors.beeYellowSoft,
    onTertiaryContainer:    AppColors.navyDeep,

    // Error
    error:            AppColors.error,
    onError:          AppColors.errorFg,
    errorContainer:   Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),

    // Surfaces
    surface:                    AppColors.backgroundLight,
    onSurface:                  AppColors.foregroundLight,
    surfaceContainerLowest:     AppColors.surfaceLight,
    surfaceContainerLow:        AppColors.mutedLight,
    surfaceContainer:           AppColors.secondaryLight,
    surfaceContainerHigh:       AppColors.secondaryLight,
    surfaceContainerHighest:    AppColors.secondaryLight,
    onSurfaceVariant:           AppColors.mutedFgLight,

    // Outline
    outline:        AppColors.borderLight,
    outlineVariant: AppColors.borderLight,

    // Inverse
    inverseSurface:   AppColors.navyDeep,
    onInverseSurface: AppColors.backgroundLight,
    inversePrimary:   AppColors.beeYellow,

    // Shadow / scrim
    shadow: Color(0xFF182040),
    scrim:  Color(0xFF000000),
  );

  // ── Dark ColorScheme ─────────────────────────────────────────────────────────
  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,

    // Primary — bee yellow (inverted in dark mode)
    primary:         AppColors.beeYellow,
    onPrimary:       AppColors.navyDeep,
    primaryContainer:        AppColors.beeYellowSoft,
    onPrimaryContainer:      AppColors.navyDeep,

    secondary:        AppColors.secondaryDark,
    onSecondary:      AppColors.foregroundDark,
    secondaryContainer:     AppColors.secondaryDark,
    onSecondaryContainer:   AppColors.foregroundDark,

    tertiary:         AppColors.beeYellow,
    onTertiary:       AppColors.navyDeep,
    tertiaryContainer:      Color(0xFF2A2000),
    onTertiaryContainer:    AppColors.beeYellowSoft,

    error:            AppColors.error,
    onError:          AppColors.errorFg,
    errorContainer:   Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),

    surface:                    AppColors.backgroundDark,
    onSurface:                  AppColors.foregroundDark,
    surfaceContainerLowest:     AppColors.surfaceDark,
    surfaceContainerLow:        AppColors.mutedDark,
    surfaceContainer:           AppColors.secondaryDark,
    surfaceContainerHigh:       AppColors.secondaryDark,
    surfaceContainerHighest:    Color(0xFF252C43),
    onSurfaceVariant:           AppColors.mutedFgDark,

    outline:        AppColors.borderDark,
    outlineVariant: AppColors.borderDark,

    inverseSurface:   AppColors.foregroundDark,
    onInverseSurface: AppColors.navyDeep,
    inversePrimary:   AppColors.navyDeep,

    shadow: Color(0xFF000000),
    scrim:  Color(0xFF000000),
  );
}
