import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../engine/utils.dart';

class CustomSearchableTextField<T extends WithDisplayableValue>
    extends StatelessWidget {
  const CustomSearchableTextField({
    super.key,
    required this.controller,
    required this.options,
    required this.onChanged,
    this.hintText,
  });

  final String? hintText;

  final TextEditingController controller;

  final List<T> options;

  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<T>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
        ),
        onChanged: onChanged,
      ),
      suggestionsCallback: (pattern) {
        return options
            .where((value) => '$value'.contains(pattern))
            .map((value) => value);
      },
      itemBuilder: (_, suggestion) => ListTile(
        title: Text(suggestion.value.toDisplayString()),
        subtitle: Text(suggestion.value.toString()),
      ),
      onSuggestionSelected: (suggestion) {
        controller.text = suggestion.value.toDisplayString();
        onChanged(suggestion.value.toDisplayString());
      },
      validator: (value) =>
          (value != null && value.isEmpty) ? 'Please select a option.' : null,
      onSaved: (value) {
        if (value != null) {
          controller.text = value;
        }
      },
    );
  }
}
