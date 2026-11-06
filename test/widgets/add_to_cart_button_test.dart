import 'package:cds_2026_05_widget_previews/models/add_to_cart_status.dart';
import 'package:cds_2026_05_widget_previews/theme/app_theme.dart';
import 'package:cds_2026_05_widget_previews/widgets/add_to_cart_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late int presses;

  Future<void> pumpButton(WidgetTester tester, AddToCartStatus status) {
    return tester.pumpWidget(
      MaterialApp(
        theme: lightTheme,
        home: Scaffold(
          body: AddToCartButton(status: status, onPressed: () => presses++),
        ),
      ),
    );
  }

  setUp(() => presses = 0);

  group('AddToCartButton:', () {
    group('when the status is normal', () {
      testWidgets('should show the label', (tester) async {
        await pumpButton(tester, AddToCartStatus.normal);
        expect(find.text('Add to Cart'), findsOneWidget);
      });

      testWidgets('should call onPressed when tapped', (tester) async {
        await pumpButton(tester, AddToCartStatus.normal);
        await tester.tap(find.byType(AddToCartButton));
        expect(presses, 1);
      });
    });

    group('when the status is loading', () {
      testWidgets('should show a progress indicator', (tester) async {
        await pumpButton(tester, AddToCartStatus.loading);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should ignore taps', (tester) async {
        await pumpButton(tester, AddToCartStatus.loading);
        await tester.tap(find.byType(AddToCartButton));
        expect(presses, 0);
      });
    });

    group('when the status is disabled', () {
      testWidgets('should show the disabled label', (tester) async {
        await pumpButton(tester, AddToCartStatus.disabled);
        expect(find.text('Out of Stock'), findsOneWidget);
      });

      testWidgets('should ignore taps', (tester) async {
        await pumpButton(tester, AddToCartStatus.disabled);
        await tester.tap(find.byType(AddToCartButton));
        expect(presses, 0);
      });
    });

    group('when the status is success', () {
      testWidgets('should confirm the item was added', (tester) async {
        await pumpButton(tester, AddToCartStatus.success);
        expect(find.text('Added to Cart'), findsOneWidget);
      });
    });
  });
}
