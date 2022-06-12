import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/theme.dart';

class ThemeButton extends ConsumerWidget {
  const ThemeButton({super.key});

  IconData getIconBasedOnTheme(ThemeMode theme) {
    // Get the icon of the next theme.
    switch (theme) {
      case ThemeMode.dark:
        return Icons.light_mode;
      case ThemeMode.light:
        return Icons.auto_mode;
      case ThemeMode.system:
        return Icons.dark_mode;
      default:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(ThemeProvider.provider);
    final themeNotifier = ref.watch(ThemeProvider.provider.notifier);

    return IconButton(
      tooltip: 'Change theme',
      onPressed: themeNotifier.toggleTheme,
      icon: Icon(getIconBasedOnTheme(theme)),
    );
  }
}
