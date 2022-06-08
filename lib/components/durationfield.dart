import 'package:flutter/material.dart';

class DurationField extends StatelessWidget {
  const DurationField({
    super.key,
    required this.hours,
    required this.minutes,
    required this.onTap,
  });

  final TextEditingController hours;
  final TextEditingController minutes;
  final void Function()? onTap;

  Widget buildField(
    final TextEditingController controller,
  ) {
    return SizedBox(
      width: 90,
      child: TextField(
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        buildField(hours),
        const SizedBox(width: 10),
        Text(
          ':',
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(width: 10),
        buildField(minutes),
        const SizedBox(width: 10),
        const Text(
          'HOURS',
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
