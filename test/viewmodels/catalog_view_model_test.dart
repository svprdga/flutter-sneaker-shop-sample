import 'package:cds_2026_05_widget_previews/data/sample_products.dart';
import 'package:cds_2026_05_widget_previews/models/product.dart';
import 'package:cds_2026_05_widget_previews/viewmodels/catalog_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CatalogViewModel viewModel;
  late int notifications;

  setUp(() {
    viewModel = CatalogViewModel(
      products: sampleProducts,
      initialFavoriteIds: {cloudStep.id},
    );
    notifications = 0;
    viewModel.addListener(() => notifications++);
  });

  group('CatalogViewModel:', () {
    group('when created', () {
      test('should expose every product', () {
        expect(viewModel.products, sampleProducts);
      });

      test('should start with the initial favorites', () {
        expect(viewModel.isFavorite(cloudStep), isTrue);
      });
    });

    group('when a category is selected', () {
      setUp(() => viewModel.selectCategory(ProductCategory.running));

      test('should only expose products of that category', () {
        expect(viewModel.products, [aeroGlide, vantaRunner]);
      });

      test('should notify listeners', () {
        expect(notifications, 1);
      });
    });

    group('when the "All" category is selected again', () {
      setUp(() {
        viewModel.selectCategory(ProductCategory.trail);
        viewModel.selectCategory(null);
      });

      test('should expose every product', () {
        expect(viewModel.products, sampleProducts);
      });
    });

    group('when searching', () {
      group('with a partial name in a different case', () {
        setUp(() => viewModel.search('  RUNNER '));

        test('should expose the matching products', () {
          expect(viewModel.products, [vantaRunner]);
        });
      });

      group('with a category selected', () {
        setUp(() {
          viewModel.selectCategory(ProductCategory.casual);
          viewModel.search('glide');
        });

        test('should combine both filters', () {
          expect(viewModel.products, isEmpty);
        });
      });

      group('with the same query twice', () {
        setUp(() {
          viewModel.search('aero');
          viewModel.search('aero');
        });

        test('should notify listeners only once', () {
          expect(notifications, 1);
        });
      });
    });

    group('when toggling a product that is not a favorite', () {
      setUp(() => viewModel.toggleFavorite(aeroGlide));

      test('should mark it as favorite', () {
        expect(viewModel.isFavorite(aeroGlide), isTrue);
      });

      test('should notify listeners', () {
        expect(notifications, 1);
      });
    });

    group('when toggling a favorite product', () {
      setUp(() => viewModel.toggleFavorite(cloudStep));

      test('should remove it from favorites', () {
        expect(viewModel.isFavorite(cloudStep), isFalse);
      });
    });

    group('when asking for related products', () {
      test('should exclude the product itself', () {
        expect(viewModel.relatedTo(vantaRunner), isNot(contains(vantaRunner)));
      });

      test('should list products of the same category first', () {
        expect(viewModel.relatedTo(vantaRunner).first, aeroGlide);
      });

      test('should respect the limit', () {
        expect(viewModel.relatedTo(vantaRunner, limit: 2), hasLength(2));
      });
    });
  });
}
