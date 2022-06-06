import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/formats.dart';

class CustomDropdownSearch extends ConsumerWidget {
  const CustomDropdownSearch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
  });

  final String value;

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
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          prefixIcon: Icon(Icons.extension),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          labelText: 'Media Format',
          hintText: 'The format the input media file must be converted',
        ),
      ),
      onChanged: onChanged,
      selectedItem: value,
    );
  }
}

/*
MediaFormats.values.map((final e) => e.value).toList()
onChanged: (final value) {
        setMediaFormat.format = MediaFormats.values.firstWhere(
          (final format) => format.toString() == value,
          orElse: () => MediaFormats.mk4,
        );
      },
      selectedItem: mediaFormat.value,
      */