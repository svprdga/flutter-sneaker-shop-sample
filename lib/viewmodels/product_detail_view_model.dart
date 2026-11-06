import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../models/add_to_cart_status.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class ProductDetailViewModel extends ChangeNotifier {
  static const int maxQuantityPerOrder = 9;

  final Product product;
  final ValueChanged<CartItem> onAddToCart;
  final Duration addingDuration;
  final Duration successDuration;

  ProductColor _selectedColor;
  ProductColor get selectedColor => _selectedColor;

  int? _selectedSize;
  int? get selectedSize => _selectedSize;

  int _quantity = 1;
  int get quantity => _quantity;

  bool _isAdding = false;
  bool _showSuccess = false;
  bool _isDisposed = false;

  ProductDetailViewModel({
    required this.product,
    required this.onAddToCart,
    int? initialSize,
    this.addingDuration = const Duration(milliseconds: 1200),
    this.successDuration = const Duration(milliseconds: 1400),
  }) : _selectedColor = product.availableColors.first,
       _selectedSize =
           initialSize != null && product.isSizeAvailable(initialSize)
           ? initialSize
           : null;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  int get maxQuantity =>
      math.max(1, math.min(maxQuantityPerOrder, product.stockCount));

  bool get canDecrementQuantity => _quantity > 1;

  bool get canIncrementQuantity =>
      product.isAvailable && _quantity < maxQuantity;

  bool get canAddToCart =>
      product.isAvailable && _selectedSize != null && !_isAdding;

  AddToCartStatus get addToCartStatus {
    if (_isAdding) return AddToCartStatus.loading;
    if (_showSuccess) return AddToCartStatus.success;
    if (!canAddToCart) return AddToCartStatus.disabled;
    return AddToCartStatus.normal;
  }

  /// Label shown on the Add to Cart button while it's disabled.
  String get disabledLabel =>
      product.isAvailable ? 'Select a size' : 'Out of Stock';

  void selectColor(ProductColor color) {
    if (color == _selectedColor) return;
    _selectedColor = color;
    notifyListeners();
  }

  void selectSize(int size) {
    if (!product.isSizeAvailable(size) || size == _selectedSize) return;
    _selectedSize = size;
    notifyListeners();
  }

  void incrementQuantity() {
    if (!canIncrementQuantity) return;
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (!canDecrementQuantity) return;
    _quantity--;
    notifyListeners();
  }

  Future<void> addToCart() async {
    if (!canAddToCart) return;
    _isAdding = true;
    _showSuccess = false;
    notifyListeners();

    await Future<void>.delayed(addingDuration);
    if (_isDisposed) return;
    onAddToCart(
      CartItem(
        product: product,
        color: _selectedColor,
        size: _selectedSize!,
        quantity: _quantity,
      ),
    );
    _isAdding = false;
    _showSuccess = true;
    notifyListeners();

    await Future<void>.delayed(successDuration);
    if (_isDisposed || _isAdding) return;
    _showSuccess = false;
    notifyListeners();
  }
}
