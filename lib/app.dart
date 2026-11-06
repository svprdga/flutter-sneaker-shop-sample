import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'data/sample_products.dart';
import 'theme/app_theme.dart';
import 'viewmodels/cart_view_model.dart';
import 'viewmodels/catalog_view_model.dart';
import 'views/catalog_screen.dart';

/// App-wide state shared by both screens: the catalog (with favorites) and
/// the cart. Also handy as a preview wrapper for full screens.
class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CatalogViewModel>(
          create: (_) => CatalogViewModel(
            products: sampleProducts,
            initialFavoriteIds: {cloudStep.id},
          ),
        ),
        ChangeNotifierProvider<CartViewModel>(create: (_) => CartViewModel()),
      ],
      child: child,
    );
  }
}

class StrideApp extends StatelessWidget {
  const StrideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp(
        title: 'Stride',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: Theme.of(context).brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: child ?? const SizedBox.shrink(),
        ),
        home: const CatalogScreen(),
      ),
    );
  }
}
