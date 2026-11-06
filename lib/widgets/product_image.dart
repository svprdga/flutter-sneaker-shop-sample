import 'package:flutter/material.dart';

import '../theme/stride_colors.dart';

/// A product photo on a white background, so photos shot on white blend in
/// seamlessly whatever their aspect ratio.
class ProductImage extends StatelessWidget {
  static const Color backgroundColor = Colors.white;

  final String imagePath;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final bool dimmed;

  const ProductImage({
    super.key,
    required this.imagePath,
    this.borderRadius = BorderRadius.zero,
    this.padding = const EdgeInsets.all(4),
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: ColoredBox(
        color: backgroundColor,
        child: Padding(
          padding: padding,
          child: Opacity(
            opacity: dimmed ? 0.45 : 1,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: context.strideColors.faint,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
