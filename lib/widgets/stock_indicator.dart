import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/stride_colors.dart';

/// Colored dot plus a short availability label.
class StockIndicator extends StatelessWidget {
  final StockStatus status;
  final int stockCount;
  final bool large;

  const StockIndicator({
    super.key,
    required this.status,
    required this.stockCount,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final StrideColors colors = context.strideColors;
    final (String label, Color color) = switch (status) {
      StockStatus.inStock => ('In stock', colors.success),
      StockStatus.lowStock => ('Only $stockCount left', colors.warning),
      StockStatus.outOfStock => (
        large ? 'Out of stock' : 'Unavailable',
        colors.faint,
      ),
    };
    final double dotSize = large ? 8 : 6;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: large ? 8 : 4,
      children: [
        Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: large ? 14 : 11,
              fontWeight: large ? FontWeight.w800 : FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
