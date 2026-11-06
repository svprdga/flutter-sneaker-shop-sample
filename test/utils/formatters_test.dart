import 'package:cds_2026_05_widget_previews/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatPrice:', () {
    group('when the price is a whole number', () {
      test('should omit the cents', () {
        expect(formatPrice(149), '\$149');
      });
    });

    group('when the price has cents', () {
      test('should show two decimals', () {
        expect(formatPrice(149.5), '\$149.50');
      });
    });
  });

  group('formatCompactCount:', () {
    group('when the count is below a thousand', () {
      test('should return the plain number', () {
        expect(formatCompactCount(212), '212');
      });
    });

    group('when the count is in the thousands', () {
      test('should abbreviate it with one decimal', () {
        expect(formatCompactCount(1284), '1.2k');
      });
    });

    group('when the count is an exact thousand', () {
      test('should drop the trailing zero decimal', () {
        expect(formatCompactCount(2000), '2k');
      });
    });
  });

  group('formatCount:', () {
    group('when the count has more than three digits', () {
      test('should add thousands separators', () {
        expect(formatCount(1234567), '1,234,567');
      });
    });

    group('when the count has three digits or fewer', () {
      test('should not add separators', () {
        expect(formatCount(341), '341');
      });
    });
  });
}
