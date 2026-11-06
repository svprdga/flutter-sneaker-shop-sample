import 'package:flutter/material.dart';

import '../theme/stride_colors.dart';

/// Round icon button on a surface-colored background.
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final double iconSize;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final bool elevated;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = 44,
    this.iconSize = 22,
    this.foregroundColor,
    this.backgroundColor,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    final StrideColors colors = context.strideColors;
    final Widget button = DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: elevated
            ? const [
                BoxShadow(
                  color: Color(0x14000000),
                  offset: Offset(0, 2),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
      child: Material(
        color: backgroundColor ?? colors.surface,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox.square(
            dimension: size,
            child: Icon(
              icon,
              size: iconSize,
              color: foregroundColor ?? colors.ink,
            ),
          ),
        ),
      ),
    );
    return Semantics(
      button: true,
      label: tooltip,
      child: tooltip == null
          ? button
          : Tooltip(
              message: tooltip,
              excludeFromSemantics: true,
              child: button,
            ),
    );
  }
}
