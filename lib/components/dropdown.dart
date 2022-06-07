import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OsumDropdown extends ConsumerWidget {
  const OsumDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
    required this.labelText,
  });

  final String value;

  final String labelText;

  final List<String> items;

  final void Function(String?) onChanged;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return DropdownSearch<String>(
      popupProps: const PopupProps.menu(
        searchFieldProps: TextFieldProps(
          scrollPhysics: BouncingScrollPhysics(),
        ),
        showSearchBox: true,
        showSelectedItems: true,
      ),
      items: items,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          prefixIcon: const Icon(Icons.extension),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          labelText: labelText,
        ),
      ),
      onChanged: onChanged,
      selectedItem: value,
    );
  }
}
