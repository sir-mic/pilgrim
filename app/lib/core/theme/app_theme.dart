import 'package:flutter/material.dart';

import 'colors.dart';

/// Typography built on the bundled Lora variable font.
///
/// Weights are applied via the `wght` variation axis so the type always
/// renders from the shipped font, never from an online fetch.
class PilgrimTypography {
  PilgrimTypography._();

  static const _family = 'Lora';

  static TextStyle _style(
    double size, {
    FontWeight weight = FontWeight.w400,
    double height = 1.4,
    double letterSpacing = 0,
    Color? color,
    FontStyle style = FontStyle.normal,
  }) {
    return TextStyle(
      fontFamily: _family,
      fontSize: size,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
      fontStyle: style,
      fontVariations: [FontVariation('wght', weight.value.toDouble())],
    );
  }

  static TextTheme textTheme(ColorScheme colors, bool dark) {
    final base = colors;
    final secondary = base.onSurfaceVariant;
    return TextTheme(
      displayLarge: _style(44, weight: FontWeight.w600, height: 1.15),
      displayMedium: _style(38, weight: FontWeight.w600, height: 1.2),
      displaySmall: _style(32, weight: FontWeight.w600, height: 1.25),
      headlineLarge: _style(28, weight: FontWeight.w600, height: 1.3),
      headlineMedium: _style(24, weight: FontWeight.w600, height: 1.3),
      headlineSmall: _style(20, weight: FontWeight.w600, height: 1.35),
      titleLarge: _style(18, weight: FontWeight.w600, height: 1.4),
      titleMedium: _style(16, weight: FontWeight.w600, height: 1.4),
      titleSmall: _style(14, weight: FontWeight.w600, height: 1.4),
      bodyLarge: _style(17, height: 1.6),
      bodyMedium: _style(15, height: 1.55),
      bodySmall: _style(13, height: 1.5, color: secondary),
      labelLarge: _style(15, weight: FontWeight.w500),
      labelMedium: _style(13, weight: FontWeight.w500),
      labelSmall: _style(11, weight: FontWeight.w500, letterSpacing: 1.1),
    );
  }
}

/// Builds the dark and light [ThemeData] for Pilgrim.
ThemeData pilgrimTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme(
    brightness: brightness,
    primary: dark ? PilgrimColors.darkAccent : PilgrimColors.lightAccent,
    onPrimary: dark ? PilgrimColors.darkBackground : Colors.white,
    secondary: dark ? PilgrimColors.darkAccentAlt : PilgrimColors.lightAccentAlt,
    onSecondary: dark ? PilgrimColors.darkBackground : Colors.white,
    error: const Color(0xFFC15B4D),
    onError: Colors.white,
    surface: dark ? PilgrimColors.darkSurface : PilgrimColors.lightSurface,
    onSurface: dark ? PilgrimColors.darkText : PilgrimColors.lightText,
    surfaceContainerHighest:
        dark ? PilgrimColors.darkSurfaceHigh : PilgrimColors.lightSurfaceHigh,
    onSurfaceVariant:
        dark ? PilgrimColors.darkTextSecondary : PilgrimColors.lightTextSecondary,
    outline: dark ? PilgrimColors.darkDivider : PilgrimColors.lightDivider,
    shadow: Colors.black,
  );

  final background =
      dark ? PilgrimColors.darkBackground : PilgrimColors.lightBackground;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: background,
    textTheme: PilgrimTypography.textTheme(scheme, dark),
    fontFamily: PilgrimTypography._family,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: PilgrimTypography._style(18, weight: FontWeight.w600,
          color: scheme.onSurface),
      iconTheme: IconThemeData(color: scheme.onSurface),
    ),
    dividerTheme: DividerThemeData(color: scheme.outline, thickness: 1),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: scheme.surfaceContainerHighest,
      contentTextStyle: PilgrimTypography._style(14, color: scheme.onSurface),
      behavior: SnackBarBehavior.floating,
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: scheme.primary),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.primary, width: 1.2),
      ),
      hintStyle: PilgrimTypography._style(15, color: scheme.onSurfaceVariant),
    ),
    progressIndicatorTheme:
        ProgressIndicatorThemeData(color: scheme.primary),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
    }),
  );
}
