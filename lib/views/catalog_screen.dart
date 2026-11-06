import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../theme/stride_colors.dart';
import '../viewmodels/cart_view_model.dart';
import '../viewmodels/catalog_view_model.dart';
import '../widgets/category_selector.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/product_grid.dart';
import '../widgets/search_field.dart';
import '../widgets/section_header.dart';
import 'product_detail_screen.dart';

/// Product listing. Expects [CatalogViewModel] and [CartViewModel] above it.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CatalogViewModel catalog = context.watch<CatalogViewModel>();
    final int cartCount = context.select<CartViewModel, int>(
      (cart) => cart.itemCount,
    );
    final StrideColors colors = context.strideColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<Product> products = catalog.products;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: _CatalogHeader(cartCount: cartCount),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      '${_greeting()}, Alex',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.muted,
                      ),
                    ),
                    Text(
                      'Find your next pair',
                      style: textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: SearchField(
                        initialValue: catalog.query,
                        onChanged: catalog.search,
                      ),
                    ),
                    _FiltersButton(colors: colors),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: CategorySelector(
                  categories: catalog.categories,
                  selected: catalog.selectedCategory,
                  onSelected: catalog.selectCategory,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SectionHeader(
                  title: catalog.selectedCategory?.label ?? 'Popular now',
                  trailing:
                      '${products.length} ${products.length == 1 ? 'item' : 'items'}',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: products.isEmpty
                    ? _EmptyResults(query: catalog.query)
                    : ProductGrid(
                        products: products,
                        favoriteIds: catalog.favoriteIds,
                        onProductTap: (product) =>
                            openProductDetail(context, product),
                        onFavoriteToggle: catalog.toggleFavorite,
                        onAddToCart: context.read<CartViewModel>().quickAdd,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final int hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }
}

class _CatalogHeader extends StatelessWidget {
  final int cartCount;

  const _CatalogHeader({required this.cartCount});

  @override
  Widget build(BuildContext context) {
    final StrideColors colors = context.strideColors;
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.ink,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'S',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: colors.background,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text('Stride', style: Theme.of(context).textTheme.titleLarge),
        ),
        const CircleIconButton(
          icon: Icons.notifications_none_rounded,
          tooltip: 'Notifications',
          onPressed: null,
        ),
        const SizedBox(width: 8),
        Stack(
          clipBehavior: Clip.none,
          children: [
            const CircleIconButton(
              icon: Icons.shopping_bag_outlined,
              tooltip: 'Cart',
              onPressed: null,
            ),
            if (cartCount > 0)
              Positioned(
                top: 4,
                right: 2,
                child: _CartBadge(
                  count: cartCount,
                  borderColor: colors.background,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _CartBadge extends StatelessWidget {
  final int count;
  final Color borderColor;

  const _CartBadge({required this.count, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 18),
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 3),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: StrideColors.badge,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          height: 1,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _FiltersButton extends StatelessWidget {
  final StrideColors colors;

  const _FiltersButton({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.ink,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox.square(
        dimension: 48,
        child: Icon(Icons.tune_rounded, size: 22, color: colors.background),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  final String query;

  const _EmptyResults({required this.query});

  @override
  Widget build(BuildContext context) {
    final String trimmed = query.trim();
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 64),
      child: Text(
        trimmed.isEmpty
            ? 'No sneakers in this category yet'
            : 'No sneakers match “$trimmed”',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: context.strideColors.muted,
        ),
      ),
    );
  }
}
