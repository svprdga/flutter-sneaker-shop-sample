import 'package:cds_2026_05_widget_previews/data/sample_products.dart';
import 'package:cds_2026_05_widget_previews/models/cart_item.dart';
import 'package:cds_2026_05_widget_previews/viewmodels/cart_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CartViewModel cart;
  late int notifications;

  CartItem vantaItem({int size = 42, int quantity = 1}) => CartItem(
    product: vantaRunner,
    color: vantaRunner.availableColors.first,
    size: size,
    quantity: quantity,
  );

  setUp(() {
    cart = CartViewModel();
    notifications = 0;
    cart.addListener(() => notifications++);
  });

  group('CartViewModel:', () {
    group('when created', () {
      test('should be empty', () {
        expect(cart.itemCount, 0);
      });
    });

    group('when adding an item', () {
      setUp(() => cart.add(vantaItem(quantity: 2)));

      test('should count its quantity', () {
        expect(cart.itemCount, 2);
      });

      test('should notify listeners', () {
        expect(notifications, 1);
      });
    });

    group('when adding the same variant twice', () {
      setUp(() {
        cart.add(vantaItem());
        cart.add(vantaItem(quantity: 2));
      });

      test('should merge them into a single line', () {
        expect(cart.items, hasLength(1));
      });

      test('should add up the quantities', () {
        expect(cart.items.single.quantity, 3);
      });
    });

    group('when adding a different size of the same product', () {
      setUp(() {
        cart.add(vantaItem());
        cart.add(vantaItem(size: 43));
      });

      test('should keep separate lines', () {
        expect(cart.items, hasLength(2));
      });
    });

    group('when quick adding', () {
      group('with an available product', () {
        setUp(() => cart.quickAdd(cloudStep));

        test('should add one unit', () {
          expect(cart.itemCount, 1);
        });

        test('should pick the first size that is not sold out', () {
          expect(cart.items.single.size, 41);
        });
      });

      group('with an out of stock product', () {
        setUp(() => cart.quickAdd(nimbusMid));

        test('should not add anything', () {
          expect(cart.itemCount, 0);
        });

        test('should not notify listeners', () {
          expect(notifications, 0);
        });
      });
    });
  });
}
