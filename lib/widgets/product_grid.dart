import 'package:flutter/material.dart';

import '../models/product.dart';
import 'product_card.dart';

/// Two-column grid of [ProductCard]s that sizes itself to its content, so it
/// can live inside a scrolling page or be rendered on its own.
class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Set<String> favoriteIds;
  final ValueChanged<Product>? onProductTap;
  final ValueChanged<Product>? onFavoriteToggle;
  final ValueChanged<Product>? onAddToCart;
  final int columns;
  final double spacing;

  const ProductGrid({
    super.key,
    required this.products,
    this.favoriteIds = const {},
    this.onProductTap,
    this.onFavoriteToggle,
    this.onAddToCart,
    this.columns = 2,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth =
            ((constraints.maxWidth - spacing * (columns - 1)) / columns)
                .floorToDouble();
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final Product product in products)
              SizedBox(
                width: cardWidth,
                child: ProductCard(
                  product: product,
                  isFavorite: favoriteIds.contains(product.id),
                  onTap: _bind(onProductTap, product),
                  onFavoriteToggle: _bind(onFavoriteToggle, product),
                  onAddToCart: _bind(onAddToCart, product),
                ),
              ),
          ],
        );
      },
    );
  }

  VoidCallback? _bind(ValueChanged<Product>? callback, Product product) =>
      callback == null ? null : () => callback(product);
}
