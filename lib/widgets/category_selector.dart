import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/stride_colors.dart';

/// Horizontal list of category chips. A `null` category means "All".
class CategorySelector extends StatelessWidget {
  final List<ProductCategory> categories;
  final ProductCategory? selected;
  final ValueChanged<ProductCategory?> onSelected;
  final EdgeInsets padding;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        spacing: 8,
        children: [
          _CategoryChip(
            label: 'All',
            isSelected: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final ProductCategory category in categories)
            _CategoryChip(
              label: category.label,
              isSelected: category == selected,
              onTap: () => onSelected(category),
            ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final StrideColors colors = context.strideColors;
    final StadiumBorder shape = StadiumBorder(
      side: BorderSide(color: isSelected ? colors.ink : colors.border),
    );
    return Semantics(
      selected: isSelected,
      button: true,
      child: Material(
        color: isSelected ? colors.ink : colors.surface,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? colors.background : colors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
