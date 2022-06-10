import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../components/theme_button.dart';

@immutable
class Route {
  const Route({
    required this.title,
    required this.icon,
    required this.content,
  });

  final String title;

  final Icon icon;

  final Widget content;

  Widget get page {
    return FadeInRight(
      duration: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [const ThemeButton(), content],
        ),
      ),
    );
  }
}
