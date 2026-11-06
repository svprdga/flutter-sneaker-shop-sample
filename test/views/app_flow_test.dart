import 'package:cds_2026_05_widget_previews/app.dart';
import 'package:cds_2026_05_widget_previews/views/product_detail_screen.dart';
import 'package:cds_2026_05_widget_previews/widgets/add_to_cart_button.dart';
import 'package:cds_2026_05_widget_previews/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const StrideApp());
  }

  Future<void> openVantaRunner(WidgetTester tester) async {
    await pumpApp(tester);
    await tester.ensureVisible(find.text('Vanta Runner'));
    await tester.tap(find.text('Vanta Runner'));
    await tester.pumpAndSettle();
  }

  Future<void> addSize42ToCart(WidgetTester tester) async {
    await openVantaRunner(tester);
    await tester.ensureVisible(find.text('42'));
    await tester.tap(find.text('42'));
    await tester.pump();
    await tester.tap(find.byType(AddToCartButton));
    await tester.pump();
  }

  group('StrideApp:', () {
    group('when launched', () {
      testWidgets('should list every product', (tester) async {
        await pumpApp(tester);
        expect(find.text('6 items'), findsOneWidget);
      });
    });

    group('when searching', () {
      testWidgets('should only list matching products', (tester) async {
        await pumpApp(tester);
        await tester.enterText(find.byType(TextField), 'cloud');
        await tester.pump();
        expect(find.byType(ProductCard), findsOneWidget);
      });

      group('with no matches', () {
        testWidgets('should show the empty state', (tester) async {
          await pumpApp(tester);
          await tester.enterText(find.byType(TextField), 'zzz');
          await tester.pump();
          expect(find.text('No sneakers match “zzz”'), findsOneWidget);
        });
      });
    });

    group('when selecting a category', () {
      testWidgets('should use it as the section title', (tester) async {
        await pumpApp(tester);
        await tester.ensureVisible(find.text('Trail'));
        await tester.tap(find.text('Trail'));
        await tester.pump();
        expect(find.text('1 item'), findsOneWidget);
      });
    });

    group('when tapping a product', () {
      testWidgets('should open its detail screen', (tester) async {
        await openVantaRunner(tester);
        expect(find.byType(ProductDetailScreen), findsOneWidget);
      });

      testWidgets('should render without layout errors', (tester) async {
        await openVantaRunner(tester);
        expect(tester.takeException(), isNull);
      });
    });

    group('when adding a product to the cart from the detail screen', () {
      testWidgets('should show the loading state first', (tester) async {
        await addSize42ToCart(tester);
        expect(find.text('Adding…'), findsOneWidget);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      });

      testWidgets('should confirm the item was added', (tester) async {
        await addSize42ToCart(tester);
        await tester.pump(const Duration(milliseconds: 1200));
        expect(find.text('Added to Cart'), findsOneWidget);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      });

      testWidgets('should update the cart badge in the catalog', (
        tester,
      ) async {
        await addSize42ToCart(tester);
        await tester.pump(const Duration(seconds: 3));
        await tester.tap(find.byTooltip('Back'));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
      });
    });
  });
}
