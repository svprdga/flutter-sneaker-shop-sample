import 'package:cds_2026_05_widget_previews/data/sample_products.dart';
import 'package:cds_2026_05_widget_previews/models/product.dart';
import 'package:cds_2026_05_widget_previews/theme/app_theme.dart';
import 'package:cds_2026_05_widget_previews/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late int taps;
  late int adds;

  Future<void> pumpCard(
    WidgetTester tester,
    Product product, {
    ThemeData? theme,
    double width = 187,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        theme: theme ?? lightTheme,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: width,
              child: ProductCard(
                product: product,
                onTap: () => taps++,
                onAddToCart: () => adds++,
              ),
            ),
          ),
        ),
      ),
    );
  }

  setUp(() {
    taps = 0;
    adds = 0;
  });

  group('ProductCard:', () {
    group('when showing a regular product', () {
      testWidgets('should show its name', (tester) async {
        await pumpCard(tester, aeroGlide);
        expect(find.text('Aero Glide'), findsOneWidget);
      });

      testWidgets('should show its price', (tester) async {
        await pumpCard(tester, aeroGlide);
        expect(find.text('\$149'), findsOneWidget);
      });

      testWidgets('should call onTap when tapped', (tester) async {
        await pumpCard(tester, aeroGlide);
        await tester.tap(find.text('Aero Glide'));
        expect(taps, 1);
      });
    });

    group('when showing a discounted product', () {
      testWidgets('should show the discount badge', (tester) async {
        await pumpCard(tester, cloudStep);
        expect(find.text('-20%'), findsOneWidget);
      });

      testWidgets('should show the original price', (tester) async {
        await pumpCard(tester, cloudStep);
        expect(find.text('\$149'), findsOneWidget);
      });
    });

    group('when showing an out of stock product', () {
      testWidgets('should show the sold out badge', (tester) async {
        await pumpCard(tester, nimbusMid);
        expect(find.text('Sold out'), findsOneWidget);
      });

      testWidgets('should ignore the add button', (tester) async {
        await pumpCard(tester, nimbusMid);
        await tester.tap(find.byIcon(Icons.add_rounded));
        expect(adds, 0);
      });
    });

    group('when tapping the add button', () {
      testWidgets('should call onAddToCart', (tester) async {
        await pumpCard(tester, aeroGlide);
        await tester.tap(find.byIcon(Icons.add_rounded));
        await tester.pump(const Duration(seconds: 2));
        expect(adds, 1);
      });

      testWidgets('should show a confirmation check', (tester) async {
        await pumpCard(tester, aeroGlide);
        await tester.tap(find.byIcon(Icons.add_rounded));
        await tester.pump();
        expect(find.byIcon(Icons.check_rounded), findsOneWidget);
        await tester.pump(const Duration(seconds: 2));
      });
    });

    group('when rendered in a narrow slot', () {
      testWidgets('should not overflow', (tester) async {
        await pumpCard(tester, vantaRunner, width: 160);
        expect(tester.takeException(), isNull);
      });
    });

    group('when rendered with the dark theme', () {
      testWidgets('should not overflow', (tester) async {
        await pumpCard(tester, vantaRunner, theme: darkTheme);
        expect(tester.takeException(), isNull);
      });
    });
  });
}
