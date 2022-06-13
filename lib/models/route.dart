import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:osumffmpeg/engine/utils.dart';
import 'package:osumffmpeg/main.dart';

import '../components/theme_button.dart';

@immutable
class Route implements WithDisplayableValue, WithDisplayString {
  const Route({
    required this.title,
    required this.icon,
    required this.content,
    required this.description,
  });

  final String title;

  final Icon icon;

  final Widget content;

  final String description;

  Widget page(ValueNotifier<int> index) {
    return FadeInRight(
      duration: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(3, 0, 0, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 400,
                    child: TypeAheadFormField<Route>(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: OsumLayout.routeJumpController,
                        decoration: const InputDecoration(
                          hintText: 'Click to search for any feature.',
                          enabledBorder: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(),
                        ),
                      ),
                      suggestionsCallback: (pattern) => OsumLayout.routes
                          .where((route) => '$route'.contains(pattern))
                          .map((route) => route.value),
                      itemBuilder: (_, suggestion) => ListTile(
                        leading: suggestion.icon,
                        title: Text(
                          suggestion.title,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          suggestion.description,
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      onSuggestionSelected: (suggestion) {
                        index.value = OsumLayout.routes.indexWhere(
                          (route) => route.title == suggestion.title,
                        );
                      },
                      validator: (value) => (value != null && value.isEmpty)
                          ? 'Please select a option.'
                          : null,
                      onSaved: (value) {
                        if (value != null) {
                          OsumLayout.routeJumpController.text = value;
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  const ThemeButton(),
                ],
              ),
            ),
            content
          ],
        ),
      ),
    );
  }

  @override
  String toDisplayString() => title;

  @override
  Route get value => this;
}
