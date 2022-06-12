import 'package:flutter/material.dart';

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
  Widget build(final BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(16),
        ),
      ),
      onPressed: onPressed,
      icon: icon,
      label: Text(label),
    );
  }
}
