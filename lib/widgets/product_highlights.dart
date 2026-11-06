import 'package:flutter/material.dart';

import '../theme/stride_colors.dart';

class ProductHighlight {
  final IconData icon;
  final String label;

  const ProductHighlight({required this.icon, required this.label});
}

/// Equal-width tiles with an icon and a short label each.
class ProductHighlights extends StatelessWidget {
  final List<ProductHighlight> highlights;

  const ProductHighlights({super.key, required this.highlights});

  @override
  Widget build(BuildContext context) {
    final StrideColors colors = context.strideColors;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          for (final ProductHighlight highlight in highlights)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  spacing: 8,
                  children: [
                    Icon(highlight.icon, size: 24, color: colors.ink),
                    Text(
                      highlight.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        color: colors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
