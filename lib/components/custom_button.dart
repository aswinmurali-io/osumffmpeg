import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
  });

  final String label;

  final Icon icon;

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
