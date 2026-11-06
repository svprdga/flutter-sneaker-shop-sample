import 'package:flutter/foundation.dart';

import 'product.dart';

@immutable
class CartItem {
  final Product product;
  final ProductColor color;
  final int size;
  final int quantity;

  const CartItem({
    required this.product,
    required this.color,
    required this.size,
    required this.quantity,
  });

  bool isSameVariant(CartItem other) =>
      other.product == product &&
      other.color.name == color.name &&
      other.size == size;

  CartItem copyWith({int? quantity}) => CartItem(
    product: product,
    color: color,
    size: size,
    quantity: quantity ?? this.quantity,
  );
}
