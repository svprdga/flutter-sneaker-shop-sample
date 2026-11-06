import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

/// In-memory shopping cart shared by both screens.
class CartViewModel extends ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  void add(CartItem item) {
    final int index = _items.indexWhere((other) => other.isSameVariant(item));
    if (index == -1) {
      _items.add(item);
    } else {
      final CartItem existing = _items[index];
      _items[index] = existing.copyWith(
        quantity: existing.quantity + item.quantity,
      );
    }
    notifyListeners();
  }

  /// Adds one unit of [product] in its default color and first free size.
  void quickAdd(Product product) {
    if (!product.isAvailable) return;
    final int? size = product.availableSizes
        .where(product.isSizeAvailable)
        .firstOrNull;
    if (size == null) return;
    add(
      CartItem(
        product: product,
        color: product.availableColors.first,
        size: size,
        quantity: 1,
      ),
    );
  }
}
