import 'package:flutter/material.dart';

import '../theme/stride_colors.dart';

/// Grid of size options. Sizes in [unavailableSizes] are struck through and
/// can't be selected.
class SizeSelector extends StatelessWidget {
  final List<int> sizes;
  final Set<int> unavailableSizes;
  final int? selected;
  final ValueChanged<int> onSelected;
  final int columns;

  const SizeSelector({
    super.key,
    required this.sizes,
    this.unavailableSizes = const {},
    required this.selected,
    required this.onSelected,
    this.columns = 6,
  });

  @override
  Widget build(BuildContext context) {
    const double spacing = 8;
    return LayoutBuilder(
      builder: (context, constraints) {
        final double optionWidth =
            ((constraints.maxWidth - spacing * (columns - 1)) / columns)
                .floorToDouble();
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final int size in sizes)
              SizedBox(
                width: optionWidth,
                height: 48,
                child: _SizeOption(
                  size: size,
                  isSelected: size == selected,
                  isAvailable: !unavailableSizes.contains(size),
                  onTap: () => onSelected(size),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SizeOption extends StatelessWidget {
  final int size;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback onTap;

  const _SizeOption({
    required this.size,
    required this.isSelected,
    required this.isAvailable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final StrideColors colors = context.strideColors;
    final Color foreground = !isAvailable
        ? colors.faint
        : isSelected
        ? colors.background
        : colors.ink;
    return Semantics(
      button: true,
      enabled: isAvailable,
      selected: isSelected,
      child: Material(
        color: isSelected ? colors.ink : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: isSelected ? colors.ink : colors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isAvailable ? onTap : null,
          child: Center(
            child: Text(
              '$size',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: foreground,
                decoration: isAvailable ? null : TextDecoration.lineThrough,
                decorationColor: foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
