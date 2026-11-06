import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';

enum ProductCategory {
  running('Running'),
  casual('Casual'),
  trail('Trail'),
  limited('Limited');

  const ProductCategory(this.label);

  final String label;
}

enum StockStatus { inStock, lowStock, outOfStock }

@immutable
class ProductColor {
  const ProductColor({required this.name, required this.value});

  final String name;
  final Color value;
}

@immutable
class Product {
  static const int lowStockThreshold = 5;

  final String id;
  final String name;
  final String subtitle;
  final String description;
  final String highlight;
  final ProductCategory category;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final String imagePath;
  final List<ProductColor> availableColors;
  final List<int> availableSizes;
  final Set<int> soldOutSizes;
  final int stockCount;

  const Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.highlight,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.imagePath,
    required this.availableColors,
    required this.availableSizes,
    this.soldOutSizes = const {},
    required this.stockCount,
  });

  bool get isAvailable => stockCount > 0;

  bool get isDiscounted => originalPrice != null && originalPrice! > price;

  /// Discount as a whole percentage (e.g. 20 for 20% off), or null.
  int? get discountPercent =>
      isDiscounted ? ((1 - price / originalPrice!) * 100).round() : null;

  StockStatus get stockStatus {
    if (stockCount <= 0) return StockStatus.outOfStock;
    if (stockCount <= lowStockThreshold) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  bool isSizeAvailable(int size) =>
      isAvailable &&
      availableSizes.contains(size) &&
      !soldOutSizes.contains(size);

  @override
  bool operator ==(Object other) => other is Product && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
