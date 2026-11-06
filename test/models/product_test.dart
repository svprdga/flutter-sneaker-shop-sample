import 'package:cds_2026_05_widget_previews/data/sample_products.dart';
import 'package:cds_2026_05_widget_previews/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product:', () {
    group('when it has an original price above the price', () {
      test('should report the rounded discount percentage', () {
        expect(cloudStep.discountPercent, 20);
      });
    });

    group('when it has no original price', () {
      test('should report no discount', () {
        expect(aeroGlide.discountPercent, isNull);
      });
    });

    group('when there is plenty of stock', () {
      test('should be in stock', () {
        expect(aeroGlide.stockStatus, StockStatus.inStock);
      });
    });

    group('when stock is at or below the low stock threshold', () {
      test('should be low on stock', () {
        expect(courtClassic.stockStatus, StockStatus.lowStock);
      });
    });

    group('when there is no stock', () {
      test('should be out of stock', () {
        expect(nimbusMid.stockStatus, StockStatus.outOfStock);
      });

      test('should not be available', () {
        expect(nimbusMid.isAvailable, isFalse);
      });

      test('should not offer any size', () {
        expect(nimbusMid.isSizeAvailable(42), isFalse);
      });
    });

    group('when checking a sold out size', () {
      test('should not be available', () {
        expect(vantaRunner.isSizeAvailable(44), isFalse);
      });
    });

    group('when checking a size in stock', () {
      test('should be available', () {
        expect(vantaRunner.isSizeAvailable(42), isTrue);
      });
    });
  });
}
