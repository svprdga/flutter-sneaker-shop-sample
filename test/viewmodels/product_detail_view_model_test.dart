import 'package:cds_2026_05_widget_previews/data/sample_products.dart';
import 'package:cds_2026_05_widget_previews/models/add_to_cart_status.dart';
import 'package:cds_2026_05_widget_previews/models/cart_item.dart';
import 'package:cds_2026_05_widget_previews/models/product.dart';
import 'package:cds_2026_05_widget_previews/viewmodels/product_detail_view_model.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<CartItem> addedItems;
  late ProductDetailViewModel viewModel;

  ProductDetailViewModel create(Product product, {int? initialSize}) =>
      ProductDetailViewModel(
        product: product,
        initialSize: initialSize,
        onAddToCart: addedItems.add,
      );

  setUp(() {
    addedItems = [];
    viewModel = create(vantaRunner);
  });

  group('ProductDetailViewModel:', () {
    group('when created', () {
      test('should select the first color', () {
        expect(viewModel.selectedColor, vantaRunner.availableColors.first);
      });

      test('should have no size selected', () {
        expect(viewModel.selectedSize, isNull);
      });

      test('should start with a quantity of one', () {
        expect(viewModel.quantity, 1);
      });

      test('should not allow adding to the cart', () {
        expect(viewModel.addToCartStatus, AddToCartStatus.disabled);
      });

      test('should ask the user to select a size', () {
        expect(viewModel.disabledLabel, 'Select a size');
      });
    });

    group('when created with an initial size', () {
      group('with an available size', () {
        setUp(() => viewModel = create(vantaRunner, initialSize: 42));

        test('should preselect it', () {
          expect(viewModel.selectedSize, 42);
        });
      });

      group('with a sold out size', () {
        setUp(() => viewModel = create(vantaRunner, initialSize: 44));

        test('should ignore it', () {
          expect(viewModel.selectedSize, isNull);
        });
      });
    });

    group('when selecting a color', () {
      setUp(() => viewModel.selectColor(vantaRunner.availableColors[2]));

      test('should update the selected color', () {
        expect(viewModel.selectedColor.name, 'Sage');
      });
    });

    group('when selecting a size', () {
      group('with an available size', () {
        setUp(() => viewModel.selectSize(42));

        test('should update the selected size', () {
          expect(viewModel.selectedSize, 42);
        });

        test('should allow adding to the cart', () {
          expect(viewModel.addToCartStatus, AddToCartStatus.normal);
        });
      });

      group('with a sold out size', () {
        setUp(() => viewModel.selectSize(44));

        test('should keep the previous selection', () {
          expect(viewModel.selectedSize, isNull);
        });
      });
    });

    group('when decrementing the quantity at one', () {
      setUp(() => viewModel.decrementQuantity());

      test('should keep a quantity of one', () {
        expect(viewModel.quantity, 1);
      });
    });

    group('when incrementing the quantity', () {
      setUp(() => viewModel.incrementQuantity());

      test('should increase it by one', () {
        expect(viewModel.quantity, 2);
      });
    });

    group('when incrementing beyond the available stock', () {
      setUp(() {
        viewModel = create(courtClassic);
        for (int i = 0; i < 10; i++) {
          viewModel.incrementQuantity();
        }
      });

      test('should stop at the stock count', () {
        expect(viewModel.quantity, courtClassic.stockCount);
      });
    });

    group('when the product is out of stock', () {
      setUp(() => viewModel = create(nimbusMid));

      test('should not allow incrementing the quantity', () {
        expect(viewModel.canIncrementQuantity, isFalse);
      });

      test('should show the add to cart button as disabled', () {
        expect(viewModel.addToCartStatus, AddToCartStatus.disabled);
      });

      test('should say it is out of stock', () {
        expect(viewModel.disabledLabel, 'Out of Stock');
      });
    });

    group('when adding to the cart', () {
      group('with a size selected', () {
        late FakeAsync async;

        setUp(() {
          async = FakeAsync();
          async.run((_) {
            viewModel.selectSize(42);
            viewModel.incrementQuantity();
            viewModel.addToCart();
          });
        });

        test('should show the loading state right away', () {
          expect(viewModel.addToCartStatus, AddToCartStatus.loading);
        });

        test('should not add anything while loading', () {
          expect(addedItems, isEmpty);
        });

        test('should add the selected variant after the delay', () {
          async.elapse(viewModel.addingDuration);
          expect(
            addedItems.single,
            isA<CartItem>()
                .having((item) => item.size, 'size', 42)
                .having((item) => item.quantity, 'quantity', 2),
          );
        });

        test('should show the success state after the delay', () {
          async.elapse(viewModel.addingDuration);
          expect(viewModel.addToCartStatus, AddToCartStatus.success);
        });

        test('should go back to the normal state afterwards', () {
          async.elapse(viewModel.addingDuration + viewModel.successDuration);
          expect(viewModel.addToCartStatus, AddToCartStatus.normal);
        });
      });

      group('without a size selected', () {
        setUp(() => viewModel.addToCart());

        test('should stay disabled', () {
          expect(viewModel.addToCartStatus, AddToCartStatus.disabled);
        });
      });
    });
  });
}
