import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/formats.dart';

class CustomDropdownSearch extends ConsumerWidget {
  const CustomDropdownSearch({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final mediaFormat = ref.watch(MediaFormatProvider.provider);
    final setMediaFormat = ref.watch(MediaFormatProvider.provider.notifier);

    return DropdownSearch<String>(
      popupProps: const PopupProps.menu(
        searchFieldProps: TextFieldProps(
          scrollPhysics: BouncingScrollPhysics(),
        ),
        showSearchBox: true,
        showSelectedItems: true,
      ),
      items: MediaFormats.values.map((final e) => e.value).toList(),
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
      onChanged: (final value) {
        setMediaFormat.format = MediaFormats.values.firstWhere(
          (final format) {
            return format.toString() == value;
          },
          orElse: () {
            return MediaFormats.mk4;
          },
        );
      },
      selectedItem: mediaFormat.value,
    );
  }
}
