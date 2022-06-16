// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../models/theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
  });

  /// Custom button's label text.
  final String label;

  /// Custom button's icon.
  final Icon icon;

  /// Optional callback when user presses the button.
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.all(ThemeProvider.isMobile ? 8 : 16),
        ),
      ),
      onPressed: onPressed,
      icon: icon,
      label: Text(label),
    );
  }
}
