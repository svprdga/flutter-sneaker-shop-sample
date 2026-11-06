import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../data/sample_products.dart';
import '../views/product_detail_screen.dart';
import 'preview_helpers.dart';

@Preview(
  group: 'ProductDetailScreen',
  name: 'Light mode',
  size: Size(390, 844),
  theme: strideTheme,
  brightness: Brightness.light,
  wrapper: withProviders,
)
Widget productDetailLightPreview() =>
    const ProductDetailScreen(product: vantaRunner, initialSize: 42);

@Preview(
  group: 'ProductDetailScreen',
  name: 'Dark mode',
  size: Size(390, 844),
  theme: strideTheme,
  brightness: Brightness.dark,
  wrapper: withProviders,
)
Widget productDetailDarkPreview() =>
    const ProductDetailScreen(product: vantaRunner, initialSize: 42);
