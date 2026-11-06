import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../theme/stride_colors.dart';
import '../utils/formatters.dart';
import '../viewmodels/cart_view_model.dart';
import '../viewmodels/catalog_view_model.dart';
import '../viewmodels/product_detail_view_model.dart';
import '../widgets/add_to_cart_button.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/color_selector.dart';
import '../widgets/product_card.dart';
import '../widgets/product_highlights.dart';
import '../widgets/product_image.dart';
import '../widgets/quantity_selector.dart';
import '../widgets/section_header.dart';
import '../widgets/size_selector.dart';
import '../widgets/stock_indicator.dart';

/// Pushes the detail screen for [product].
void openProductDetail(BuildContext context, Product product) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => ProductDetailScreen(product: product),
    ),
  );
}

/// Product detail. Creates its own [ProductDetailViewModel] and expects
/// [CatalogViewModel] (favorites, suggestions) and [CartViewModel] above it.
class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final int? initialSize;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.initialSize,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductDetailViewModel>(
      create: (context) => ProductDetailViewModel(
        product: product,
        initialSize: initialSize,
        onAddToCart: context.read<CartViewModel>().add,
      ),
      child: const _ProductDetailView(),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  static const double _heroImageHeight = 304;
  static const double _sheetOverlap = 24;

  const _ProductDetailView();

  @override
  Widget build(BuildContext context) {
    final ProductDetailViewModel viewModel = context
        .watch<ProductDetailViewModel>();
    final CatalogViewModel catalog = context.watch<CatalogViewModel>();
    final StrideColors colors = context.strideColors;
    final Product product = viewModel.product;
    final bool isFavorite = catalog.isFavorite(product);
    final double topInset = MediaQuery.paddingOf(context).top;
    final double heroHeight = topInset + _heroImageHeight + 40;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: heroHeight,
                  child: ProductImage(
                    imagePath: product.imagePath,
                    padding: EdgeInsets.fromLTRB(24, topInset, 24, 40),
                    dimmed: !product.isAvailable,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: heroHeight - _sheetOverlap),
                  padding: const EdgeInsets.only(top: 24, bottom: 32),
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 24,
                    children: [
                      _padded(_ProductSummary(product: product)),
                      _padded(
                        Text(
                          product.description,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: colors.muted, height: 1.55),
                        ),
                      ),
                      _padded(_buildColorSection(viewModel, colors)),
                      _padded(_buildSizeSection(viewModel, colors)),
                      _padded(_buildQuantityRow(viewModel, colors)),
                      _padded(
                        ProductHighlights(
                          highlights: [
                            ProductHighlight(
                              icon: Icons.air_rounded,
                              label: product.highlight,
                            ),
                            const ProductHighlight(
                              icon: Icons.local_shipping_outlined,
                              label: 'Free delivery',
                            ),
                            const ProductHighlight(
                              icon: Icons.replay_rounded,
                              label: '30-day returns',
                            ),
                          ],
                        ),
                      ),
                      _buildRelatedProducts(context, catalog, product),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: topInset + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleIconButton(
                  icon: Icons.arrow_back_rounded,
                  tooltip: 'Back',
                  elevated: true,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                CircleIconButton(
                  icon: isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  tooltip: isFavorite
                      ? 'Remove from favorites'
                      : 'Add to favorites',
                  elevated: true,
                  foregroundColor: isFavorite ? colors.sale : colors.ink,
                  onPressed: () => catalog.toggleFavorite(product),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomActions(viewModel: viewModel),
    );
  }

  Widget _padded(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: child,
  );

  Widget _buildColorSection(
    ProductDetailViewModel viewModel,
    StrideColors colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        _OptionLabel(title: 'Color', detail: viewModel.selectedColor.name),
        ColorSelector(
          colors: viewModel.product.availableColors,
          selected: viewModel.selectedColor,
          onSelected: viewModel.selectColor,
        ),
      ],
    );
  }

  Widget _buildSizeSection(
    ProductDetailViewModel viewModel,
    StrideColors colors,
  ) {
    final Product product = viewModel.product;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Expanded(
              child: _OptionLabel(title: 'Size', detail: 'EU'),
            ),
            Text(
              'Size guide',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: colors.ink,
                decoration: TextDecoration.underline,
                decorationColor: colors.ink,
              ),
            ),
          ],
        ),
        SizeSelector(
          sizes: product.availableSizes,
          unavailableSizes: {
            for (final int size in product.availableSizes)
              if (!product.isSizeAvailable(size)) size,
          },
          selected: viewModel.selectedSize,
          onSelected: viewModel.selectSize,
        ),
      ],
    );
  }

  Widget _buildQuantityRow(
    ProductDetailViewModel viewModel,
    StrideColors colors,
  ) {
    final Product product = viewModel.product;
    return Row(
      spacing: 16,
      children: [
        QuantitySelector(
          quantity: viewModel.quantity,
          onDecrement: viewModel.canDecrementQuantity
              ? viewModel.decrementQuantity
              : null,
          onIncrement: viewModel.canIncrementQuantity
              ? viewModel.incrementQuantity
              : null,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 4,
            children: [
              StockIndicator(
                status: product.stockStatus,
                stockCount: product.stockCount,
                large: true,
              ),
              Text(
                product.isAvailable
                    ? 'Ships in 1–2 business days'
                    : 'Check back soon for a restock',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.muted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedProducts(
    BuildContext context,
    CatalogViewModel catalog,
    Product product,
  ) {
    final List<Product> related = catalog.relatedTo(product);
    if (related.isEmpty) return const SizedBox.shrink();
    final CartViewModel cart = context.read<CartViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        _padded(
          const SectionHeader(title: 'You may also like', trailing: 'See all'),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              for (final Product other in related)
                SizedBox(
                  width: 160,
                  child: ProductCard(
                    product: other,
                    isFavorite: catalog.isFavorite(other),
                    onTap: () => openProductDetail(context, other),
                    onFavoriteToggle: () => catalog.toggleFavorite(other),
                    onAddToCart: () => cart.quickAdd(other),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductSummary extends StatelessWidget {
  final Product product;

  const _ProductSummary({required this.product});

  @override
  Widget build(BuildContext context) {
    final StrideColors colors = context.strideColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double? originalPrice = product.originalPrice;
    final int filledStars = product.rating.round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          product.subtitle,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: colors.muted,
          ),
        ),
        Text(
          product.name,
          style: textTheme.headlineMedium?.copyWith(height: 1.1),
        ),
        Row(
          spacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                for (int i = 0; i < 5; i++)
                  Icon(
                    i < filledStars
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 16,
                    color: colors.star,
                  ),
              ],
            ),
            Text(
              product.rating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            Flexible(
              child: Text(
                '${formatCount(product.reviewCount)} reviews',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.muted,
                  decoration: TextDecoration.underline,
                  decorationColor: colors.muted,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            spacing: 8,
            children: [
              Text(
                formatPrice(product.price),
                style: textTheme.headlineMedium?.copyWith(letterSpacing: -0.4),
              ),
              if (originalPrice != null && product.isDiscounted) ...[
                Text(
                  formatPrice(originalPrice),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.faint,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: colors.faint,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: StrideColors.badge,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '-${product.discountPercent}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _OptionLabel extends StatelessWidget {
  final String title;
  final String detail;

  const _OptionLabel({required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: title,
        children: [
          TextSpan(
            text: ' · $detail',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: context.strideColors.muted,
            ),
          ),
        ],
      ),
      style: Theme.of(context).textTheme.titleSmall,
    );
  }
}

class _BottomActions extends StatelessWidget {
  final ProductDetailViewModel viewModel;

  const _BottomActions({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final StrideColors colors = context.strideColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            spacing: 8,
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: viewModel.canAddToCart
                        ? () => _showCheckoutUnavailable(context)
                        : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.ink,
                      side: BorderSide(
                        width: 1.5,
                        color: viewModel.canAddToCart
                            ? colors.ink
                            : colors.border,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Buy Now', maxLines: 1),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: AddToCartButton(
                  status: viewModel.addToCartStatus,
                  disabledLabel: viewModel.disabledLabel,
                  onPressed: viewModel.addToCart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCheckoutUnavailable(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Checkout isn’t part of this demo')),
      );
  }
}
