import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../app.dart';
import '../theme/app_theme.dart';

/// Renders previews with the app's light and dark themes.
PreviewThemeData strideTheme() => const StridePreviewTheme();

/// Provides the app-wide view models that full screens read from Provider.
Widget withProviders(Widget child) => AppProviders(child: child);

/// Applies the Stride light or dark theme based on the brightness selected
/// in the previewer (exposed through [MediaQueryData.platformBrightness]).
final class StridePreviewTheme extends PreviewThemeData {
  const StridePreviewTheme();

  @override
  Widget apply(BuildContext context, Widget child) {
    final bool isDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    return Theme(
      data: isDark ? darkTheme : lightTheme,
      // Re-applies the default text style from our theme (Manrope).
      child: Material(type: MaterialType.transparency, child: child),
    );
  }
}
