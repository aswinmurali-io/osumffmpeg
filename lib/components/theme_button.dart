import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/theme.dart';

class ThemeButton extends ConsumerWidget {
  const ThemeButton({super.key});

  IconData getIconBasedOnTheme(final ThemeMode theme) {
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
  Widget build(final BuildContext context, final WidgetRef ref) {
    final theme = ref.watch(ThemeProvider.provider);
    final themeNotifier = ref.watch(ThemeProvider.provider.notifier);

    return ElevatedButton.icon(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      onPressed: themeNotifier.toggleTheme,
      icon: Icon(getIconBasedOnTheme(theme)),
      label: const Padding(
        padding: EdgeInsets.all(12),
        child: Text('Change Theme'),
      ),
    );
  }
}
