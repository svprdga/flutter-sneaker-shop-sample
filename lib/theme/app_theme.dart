import 'package:flutter/material.dart';

import 'stride_colors.dart';

const String _fontFamily = 'Manrope';

final ThemeData lightTheme = _buildTheme(StrideColors.light, Brightness.light);

final ThemeData darkTheme = _buildTheme(StrideColors.dark, Brightness.dark);

ThemeData _buildTheme(StrideColors colors, Brightness brightness) {
  final ColorScheme colorScheme = ColorScheme(
    brightness: brightness,
    primary: colors.ink,
    onPrimary: colors.onInk,
    secondary: colors.success,
    onSecondary: colors.onSuccess,
    error: colors.sale,
    onError: Colors.white,
    surface: colors.background,
    onSurface: colors.ink,
    onSurfaceVariant: colors.muted,
    surfaceContainerLowest: colors.surface,
    surfaceContainerLow: colors.surface,
    surfaceContainer: colors.surface,
    surfaceContainerHigh: colors.surfaceMuted,
    surfaceContainerHighest: colors.surfaceMuted,
    outline: colors.border,
    outlineVariant: colors.border,
  );

  final TextTheme textTheme =
      const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
          height: 1.15,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
        titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        bodyLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ).apply(
        fontFamily: _fontFamily,
        bodyColor: colors.ink,
        displayColor: colors.ink,
      );

  final OutlineInputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: colors.border),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: _fontFamily,
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: colors.background,
    extensions: [colors],
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surface,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      hintStyle: textTheme.bodyLarge?.copyWith(color: colors.muted),
      prefixIconColor: colors.muted,
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: inputBorder.copyWith(
        borderSide: BorderSide(color: colors.ink),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: colors.ink,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colors.background,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
