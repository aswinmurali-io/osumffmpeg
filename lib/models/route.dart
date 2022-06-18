// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

import '../components/theme_button.dart';
import '../engine/utils.dart';
import '../layout.dart';
import 'theme.dart';

@immutable
class Route implements WithDisplayableValue, WithDisplayString {
  Route({
    required this.title,
    required this.icon,
    required this.content,
    required this.description,
  }) : controller = ScrollController();

  final String title;

  final Icon icon;

  final Widget content;

  final String description;

  final ScrollController controller;

  Widget page(BuildContext context, ValueNotifier<int> index) {
    return WebSmoothScroll(
      scrollOffset: 80,
      animationDuration: 300,
      controller: controller,
      child: Scrollbar(
        controller: controller,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          child: FadeInRight(
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
                          width: ThemeProvider.isMobile
                              ? MediaQuery.of(context).size.width / 1.3
                              : 400,
                          child: TypeAheadFormField<Route>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: OsumLayout.routeJumpController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText:
                                    'Click here to search for any feature.',
                                hintStyle: Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                enabledBorder: Theme.of(context)
                                    .inputDecorationTheme
                                    .enabledBorder
                                    ?.copyWith(
                                      borderSide: const BorderSide(
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                // focusedBorder: const UnderlineInputBorder(),
                              ),
                            ),
                            suggestionsCallback: (pattern) => OsumLayout.routes
                                .where((route) => '$route'.contains(pattern))
                                .map((route) => route.value),
                            itemBuilder: (_, suggestion) => ListTile(
                              leading: suggestion.icon,
                              title: Text(suggestion.title),
                              subtitle: Text(suggestion.description),
                              isThreeLine: true,
                            ),
                            onSuggestionSelected: (suggestion) {
                              index.value = OsumLayout.routes.indexWhere(
                                (route) => route.title == suggestion.title,
                              );
                            },
                            validator: (value) =>
                                (value != null && value.isEmpty)
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
          ),
        ),
      ),
    );
  }

  @override
  String toDisplayString() => title;

  @override
  Route get value => this;
}
