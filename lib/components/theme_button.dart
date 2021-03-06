// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/theme.dart';

class ThemeButtonAsset {
  const ThemeButtonAsset(this.label, this.icon);

  final IconData icon;

  final String label;
}

class ThemeButton extends ConsumerWidget {
  const ThemeButton({super.key});

  ThemeButtonAsset getAsset(ThemeMode theme) {
    // Get the icon of the next theme.
    switch (theme) {
      case ThemeMode.dark:
        return const ThemeButtonAsset('Light Mode', Icons.light_mode);
      case ThemeMode.light:
        return const ThemeButtonAsset('Auto', Icons.auto_mode);
      case ThemeMode.system:
        return const ThemeButtonAsset('Dark Mode', Icons.dark_mode);
      default:
        //
        return const ThemeButtonAsset('Change Theme', Icons.error_outline);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(ThemeProvider.provider);
    final themeNotifier = ref.watch(ThemeProvider.provider.notifier);

    final asset = getAsset(theme);

    return ThemeProvider.isMobile
        ? IconButton(
            onPressed: themeNotifier.toggleTheme,
            icon: Icon(asset.icon),
          )
        : TextButton.icon(
            onPressed: themeNotifier.toggleTheme,
            icon: Icon(asset.icon),
            label: Text(asset.label),
          );
  }
}
