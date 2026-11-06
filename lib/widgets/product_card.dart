import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../data/sample_products.dart';
import '../models/product.dart';
import '../previews/preview_helpers.dart';
import '../theme/stride_colors.dart';
import '../utils/formatters.dart';
import 'circle_icon_button.dart';
import 'product_image.dart';
import 'stock_indicator.dart';

/// Catalog tile showing a product's photo, price, rating and availability.
///
/// Fully driven by its constructor, so it can be rendered on its own.
class ProductCard extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteToggle,
    this.onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  static const Duration _addedFeedbackDuration = Duration(milliseconds: 1200);

  bool _showAdded = false;
  Timer? _addedTimer;

  @override
  void dispose() {
    _addedTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StrideColors colors = context.strideColors;
    final Product product = widget.product;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.cardBorder),
        boxShadow: colors.cardShadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                _buildImage(colors, product),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                  child: _buildDetails(colors, product),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(StrideColors colors, Product product) {
    final int? discount = product.discountPercent;
    return SizedBox(
      height: 136,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ProductImage(
            imagePath: product.imagePath,
            borderRadius: BorderRadius.circular(12),
            dimmed: !product.isAvailable,
          ),
          if (!product.isAvailable)
            Positioned(
              top: 8,
              left: 8,
              child: _Badge(
                label: 'Sold out',
                background: colors.ink,
                foreground: colors.surface,
              ),
            )
          else if (discount != null)
            Positioned(
              top: 8,
              left: 8,
              child: _Badge(
                label: '-$discount%',
                background: StrideColors.badge,
                foreground: Colors.white,
              ),
            ),
          Positioned(
            top: 8,
            right: 8,
            child: CircleIconButton(
              icon: widget.isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              tooltip: widget.isFavorite
                  ? 'Remove from favorites'
                  : 'Add to favorites',
              onPressed: widget.onFavoriteToggle,
              size: 32,
              iconSize: 18,
              foregroundColor: widget.isFavorite ? colors.sale : colors.ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(StrideColors colors, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          product.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.muted,
          ),
        ),
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            height: 1.25,
            color: colors.ink,
          ),
        ),
        Row(
          spacing: 8,
          children: [
            Expanded(child: _buildRating(colors, product)),
            StockIndicator(
              status: product.stockStatus,
              stockCount: product.stockCount,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            spacing: 8,
            children: [
              Expanded(child: _buildPrice(colors, product)),
              _buildAddButton(colors, product),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRating(StrideColors colors, Product product) {
    return Row(
      spacing: 4,
      children: [
        Icon(Icons.star_rounded, size: 16, color: colors.star),
        Text(
          product.rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: colors.ink,
          ),
        ),
        Flexible(
          child: Text(
            '(${formatCompactCount(product.reviewCount)})',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.muted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrice(StrideColors colors, Product product) {
    final double? originalPrice = product.originalPrice;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      spacing: 8,
      children: [
        Text(
          formatPrice(product.price),
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: product.isDiscounted ? colors.sale : colors.ink,
          ),
        ),
        if (product.isDiscounted && originalPrice != null)
          Flexible(
            child: Text(
              formatPrice(originalPrice),
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.faint,
                decoration: TextDecoration.lineThrough,
                decorationColor: colors.faint,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddButton(StrideColors colors, Product product) {
    final bool enabled = product.isAvailable && widget.onAddToCart != null;
    final Color background = !product.isAvailable
        ? colors.surfaceMuted
        : _showAdded
        ? colors.success
        : colors.ink;
    final Color foreground = !product.isAvailable
        ? colors.faint
        : _showAdded
        ? Colors.white
        : colors.surface;

    return Semantics(
      button: true,
      label: 'Add to cart',
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? _handleAddToCart : null,
          child: SizedBox.square(
            dimension: 36,
            child: Icon(
              _showAdded ? Icons.check_rounded : Icons.add_rounded,
              size: 20,
              color: foreground,
            ),
          ),
        ),
      ),
    );
  }

  void _handleAddToCart() {
    widget.onAddToCart?.call();
    setState(() => _showAdded = true);
    _addedTimer?.cancel();
    _addedTimer = Timer(_addedFeedbackDuration, () {
      if (mounted) setState(() => _showAdded = false);
    });
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const _Badge({
    required this.label,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          height: 1,
          color: foreground,
        ),
      ),
    );
  }
}

@Preview(
  group: 'ProductCard',
  name: 'Default',
  size: Size(187, 269),
  theme: strideTheme,
  brightness: Brightness.light,
)
Widget productCardDefaultPreview() => const ProductCard(product: aeroGlide);

@Preview(
  group: 'ProductCard',
  name: 'Discounted',
  size: Size(187, 269),
  theme: strideTheme,
  brightness: Brightness.light,
)
Widget productCardDiscountedPreview() =>
    const ProductCard(product: cloudStep, isFavorite: true);

@Preview(
  group: 'ProductCard',
  name: 'Out of stock',
  size: Size(187, 269),
  theme: strideTheme,
  brightness: Brightness.light,
)
Widget productCardOutOfStockPreview() => const ProductCard(product: nimbusMid);

@Preview(
  group: 'ProductCard',
  name: 'Dark mode',
  size: Size(187, 269),
  theme: strideTheme,
  brightness: Brightness.dark,
)
Widget productCardDarkPreview() => const ProductCard(product: vantaRunner);
