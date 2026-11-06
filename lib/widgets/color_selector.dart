import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/stride_colors.dart';

/// Row of round color swatches; the selected one gets an outer ring.
class ColorSelector extends StatelessWidget {
  final List<ProductColor> colors;
  final ProductColor selected;
  final ValueChanged<ProductColor> onSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final StrideColors theme = context.strideColors;
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        for (final ProductColor color in colors)
          Semantics(
            label: color.name,
            selected: color.name == selected.name,
            button: true,
            child: InkWell(
              onTap: () => onSelected(color),
              customBorder: const CircleBorder(),
              child: Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: color.name == selected.name
                        ? theme.ink
                        : Colors.transparent,
                  ),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color.value,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0x14000000)),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
