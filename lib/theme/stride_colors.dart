import 'package:flutter/material.dart';

/// Design tokens that don't map cleanly onto [ColorScheme].
@immutable
class StrideColors extends ThemeExtension<StrideColors> {
  static const StrideColors light = StrideColors(
    background: Color(0xFFF6F5F2),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFEFEDE8),
    ink: Color(0xFF16161A),
    onInk: Color(0xFFFFFFFF),
    muted: Color(0xFF6B6964),
    faint: Color(0xFFA3A09A),
    border: Color(0xFFE6E3DD),
    cardBorder: Colors.transparent,
    success: Color(0xFF267A4D),
    onSuccess: Color(0xFFFFFFFF),
    warning: Color(0xFF9A5F08),
    star: Color(0xFFF2A93B),
    sale: Color(0xFFD2432E),
    disabledBackground: Color(0xFFE6E3DD),
    disabledForeground: Color(0xFF8E8B85),
    cardShadow: [
      BoxShadow(color: Color(0x0A16161A), offset: Offset(0, 1), blurRadius: 2),
      BoxShadow(color: Color(0x0F16161A), offset: Offset(0, 4), blurRadius: 16),
    ],
  );

  static const StrideColors dark = StrideColors(
    background: Color(0xFF0F0F11),
    surface: Color(0xFF1A1A1E),
    surfaceMuted: Color(0xFF26262B),
    ink: Color(0xFFF4F2EE),
    onInk: Color(0xFF16161A),
    muted: Color(0xFFA19E98),
    faint: Color(0xFF6E6C68),
    border: Color(0xFF2A2A30),
    cardBorder: Color(0xFF26262B),
    success: Color(0xFF4CB57D),
    onSuccess: Color(0xFF16161A),
    warning: Color(0xFFE0A040),
    star: Color(0xFFF2B54B),
    sale: Color(0xFFF0644C),
    disabledBackground: Color(0xFF26262B),
    disabledForeground: Color(0xFF6E6C68),
    cardShadow: [],
  );

  /// Badge red used on both themes for discount and cart count badges.
  static const Color badge = Color(0xFFD2432E);

  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color ink;
  final Color onInk;
  final Color muted;
  final Color faint;
  final Color border;
  final Color cardBorder;
  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color star;
  final Color sale;
  final Color disabledBackground;
  final Color disabledForeground;
  final List<BoxShadow> cardShadow;

  const StrideColors({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.ink,
    required this.onInk,
    required this.muted,
    required this.faint,
    required this.border,
    required this.cardBorder,
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.star,
    required this.sale,
    required this.disabledBackground,
    required this.disabledForeground,
    required this.cardShadow,
  });

  @override
  StrideColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? ink,
    Color? onInk,
    Color? muted,
    Color? faint,
    Color? border,
    Color? cardBorder,
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? star,
    Color? sale,
    Color? disabledBackground,
    Color? disabledForeground,
    List<BoxShadow>? cardShadow,
  }) {
    return StrideColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      ink: ink ?? this.ink,
      onInk: onInk ?? this.onInk,
      muted: muted ?? this.muted,
      faint: faint ?? this.faint,
      border: border ?? this.border,
      cardBorder: cardBorder ?? this.cardBorder,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      star: star ?? this.star,
      sale: sale ?? this.sale,
      disabledBackground: disabledBackground ?? this.disabledBackground,
      disabledForeground: disabledForeground ?? this.disabledForeground,
      cardShadow: cardShadow ?? this.cardShadow,
    );
  }

  @override
  StrideColors lerp(StrideColors? other, double t) {
    if (other == null) return this;
    return StrideColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      onInk: Color.lerp(onInk, other.onInk, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      faint: Color.lerp(faint, other.faint, t)!,
      border: Color.lerp(border, other.border, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      star: Color.lerp(star, other.star, t)!,
      sale: Color.lerp(sale, other.sale, t)!,
      disabledBackground: Color.lerp(
        disabledBackground,
        other.disabledBackground,
        t,
      )!,
      disabledForeground: Color.lerp(
        disabledForeground,
        other.disabledForeground,
        t,
      )!,
      cardShadow: t < 0.5 ? cardShadow : other.cardShadow,
    );
  }
}

extension StrideColorsContext on BuildContext {
  /// Stride design tokens for the current theme.
  ///
  /// Falls back to the default light/dark tokens when the theme doesn't
  /// register [StrideColors], so widgets also render under a plain theme.
  StrideColors get strideColors {
    final ThemeData theme = Theme.of(this);
    return theme.extension<StrideColors>() ??
        (theme.brightness == Brightness.dark
            ? StrideColors.dark
            : StrideColors.light);
  }
}
