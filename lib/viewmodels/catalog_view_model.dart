import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CatalogViewModel extends ChangeNotifier {
  final List<Product> _allProducts;

  final Set<String> _favoriteIds;
  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  ProductCategory? _selectedCategory;
  ProductCategory? get selectedCategory => _selectedCategory;

  String _query = '';
  String get query => _query;

  CatalogViewModel({
    required List<Product> products,
    Set<String> initialFavoriteIds = const {},
  }) : _allProducts = List.unmodifiable(products),
       _favoriteIds = {...initialFavoriteIds};

  List<ProductCategory> get categories => ProductCategory.values;

  /// Products matching the selected category and the search query.
  List<Product> get products {
    final String normalizedQuery = _query.trim().toLowerCase();
    return _allProducts
        .where(
          (product) =>
              _selectedCategory == null ||
              product.category == _selectedCategory,
        )
        .where(
          (product) =>
              normalizedQuery.isEmpty ||
              product.name.toLowerCase().contains(normalizedQuery),
        )
        .toList(growable: false);
  }

  bool isFavorite(Product product) => _favoriteIds.contains(product.id);

  void toggleFavorite(Product product) {
    if (!_favoriteIds.remove(product.id)) _favoriteIds.add(product.id);
    notifyListeners();
  }

  void selectCategory(ProductCategory? category) {
    if (category == _selectedCategory) return;
    _selectedCategory = category;
    notifyListeners();
  }

  void search(String query) {
    if (query == _query) return;
    _query = query;
    notifyListeners();
  }

  /// Other products to suggest next to [product], same category first.
  List<Product> relatedTo(Product product, {int limit = 3}) {
    final List<Product> others = _allProducts
        .where((other) => other != product)
        .toList();
    others.sort((a, b) {
      final int aMatch = a.category == product.category ? 0 : 1;
      final int bMatch = b.category == product.category ? 0 : 1;
      return aMatch.compareTo(bMatch);
    });
    return others.take(limit).toList(growable: false);
  }
}
