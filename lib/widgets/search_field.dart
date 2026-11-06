import 'package:flutter/material.dart';

/// Rounded search input with a leading search icon.
class SearchField extends StatelessWidget {
  final String? initialValue;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SearchField({
    super.key,
    this.initialValue,
    this.hintText = 'Search sneakers',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded, size: 22),
      ),
    );
  }
}
