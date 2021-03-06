// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../engine/utils.dart';

class CustomSearchableTextField<T extends WithDisplayableValue>
    extends StatelessWidget {
  const CustomSearchableTextField({
    super.key,
    required this.controller,
    required this.options,
    required this.onChanged,
    this.inputFormatters,
    this.hintText,
  });

  final String? hintText;

  final TextEditingController controller;

  final List<T> options;

  final void Function(String) onChanged;

  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<T>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        inputFormatters: inputFormatters,
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
