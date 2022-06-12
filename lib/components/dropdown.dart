import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDropdown extends ConsumerWidget {
  const CustomDropdown({
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
  Widget build(BuildContext context, WidgetRef ref) {
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
            borderSide: BorderSide(color: Colors.yellow),
          ),
          labelText: labelText,
        ),
      ),
      onChanged: onChanged,
      selectedItem: value,
    );
  }
}
