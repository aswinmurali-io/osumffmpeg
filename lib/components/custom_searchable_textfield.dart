import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../engine/utils.dart';

class CustomSearchableTextField<T extends WithValue> extends StatelessWidget {
  const CustomSearchableTextField({
    super.key,
    required this.controller,
    required this.options,
  });

  final TextEditingController controller;

  final List<T> options;

  @override
  Widget build(final BuildContext context) {
    return TypeAheadFormField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
      ),
      suggestionsCallback: (final pattern) => options
          .where((final value) => '$value'.contains(pattern))
          .map((final value) => value.value.toDisplayString()),
      itemBuilder: (final _, final suggestion) => ListTile(
        title: Text(
          suggestion,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      onSuggestionSelected: (final suggestion) => controller.text = suggestion,
      validator: (final value) =>
          (value != null && value.isEmpty) ? 'Please select a option.' : null,
      onSaved: (final value) {
        if (value != null) {
          controller.text = value;
        }
      },
    );
  }
}
