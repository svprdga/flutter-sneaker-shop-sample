# Stride: Flutter Widget Previews demo

A small sneaker shop app used to demonstrate **Flutter Widget Previews**. It has
two screens (catalog and product detail) built from small, constructor-driven
widgets that render in isolation, which makes them easy to preview.

## Features

- Product catalog with search, category filters, favorites and quick add.
- Product detail with color, size and quantity selection, stock status and an
  animated Add to Cart flow.
- Light and dark themes.
- All data lives in memory: no backend, network or persistence.

## Architecture

A lightweight MVVM setup with [`provider`](https://pub.dev/packages/provider)
and `ChangeNotifier`:

```text
lib/
├── models/       Plain Dart data classes
├── data/         In-memory sample products
├── viewmodels/   ChangeNotifier screen state (catalog, detail, cart)
├── views/        Screens that consume the view models
├── widgets/      Reusable, Provider-free UI components
├── theme/        Colors, typography and ThemeData
└── utils/        Formatting helpers
```

## Previewing widgets

Presentational widgets (`ProductCard`, `AddToCartButton`, `ProductGrid`,
`ColorSelector`, `SizeSelector`…) take everything through their constructors,
so they can be previewed without any setup.

Full screens read shared state from Provider. Wrap them with `AppProviders`
(from `lib/app.dart`) in the preview's `wrapper`.

## Running

```bash
flutter pub get
flutter run
flutter test
```

## Credits

- Typeface: [Manrope](https://github.com/googlefonts/manrope), licensed under
  the SIL Open Font License 1.1 (see `assets/fonts/OFL.txt`).
- Product names and brand are fictional.
