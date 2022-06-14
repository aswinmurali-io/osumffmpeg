import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../engine/utils.dart';

class CustomSearchableTextField<T extends WithDisplayableValue>
    extends StatelessWidget {
  const CustomSearchableTextField({
    super.key,
    required this.controller,
    required this.options,
  });

  final TextEditingController controller;

  final List<T> options;

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
      ),
      suggestionsCallback: (pattern) {
        return options
            .where((value) => '$value'.contains(pattern))
            .map((value) => value.value.toDisplayString());
      },
      itemBuilder: (_, suggestion) => ListTile(
        title: Text(suggestion),
      ),
      onSuggestionSelected: (suggestion) {
        controller.text = suggestion;
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
