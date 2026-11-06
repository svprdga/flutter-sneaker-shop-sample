import 'package:flutter/material.dart';

import '../models/add_to_cart_status.dart';
import '../theme/stride_colors.dart';

/// Primary "Add to Cart" action with normal, loading, disabled and
/// success states. It only reacts to taps in the [AddToCartStatus.normal]
/// state.
class AddToCartButton extends StatelessWidget {
  final AddToCartStatus status;
  final VoidCallback? onPressed;
  final String label;
  final String disabledLabel;

  const AddToCartButton({
    super.key,
    required this.status,
    this.onPressed,
    this.label = 'Add to Cart',
    this.disabledLabel = 'Out of Stock',
  });

  @override
  Widget build(BuildContext context) {
    final StrideColors colors = context.strideColors;
    final (Color background, Color foreground) = switch (status) {
      AddToCartStatus.disabled => (
        colors.disabledBackground,
        colors.disabledForeground,
      ),
      AddToCartStatus.success => (colors.success, colors.onSuccess),
      _ => (colors.ink, colors.onInk),
    };
    final String text = switch (status) {
      AddToCartStatus.normal => label,
      AddToCartStatus.loading => 'Adding…',
      AddToCartStatus.disabled => disabledLabel,
      AddToCartStatus.success => 'Added to Cart',
    };

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: status == AddToCartStatus.normal ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: background,
          disabledForegroundColor: foreground,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            if (status == AddToCartStatus.loading)
              SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foreground,
                  backgroundColor: foreground.withValues(alpha: 0.3),
                ),
              )
            else
              Icon(_iconFor(status), size: 20),
            Flexible(
              child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(AddToCartStatus status) => switch (status) {
    AddToCartStatus.success => Icons.check_rounded,
    AddToCartStatus.disabled => Icons.block_rounded,
    _ => Icons.shopping_bag_outlined,
  };
}
