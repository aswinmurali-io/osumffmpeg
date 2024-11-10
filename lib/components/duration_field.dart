// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'head_text.dart';

class DurationController {
  /// Duration controller can be used to handle state in the
  /// [DurationField] widget.
  DurationController()
      : hours = useTextEditingController(),
        minutes = useTextEditingController(),
        seconds = useTextEditingController();

  /// The text field controller with the [hours].
  final TextEditingController hours;

  /// The text field controller with the [minutes].
  final TextEditingController minutes;

  /// The text field controller with the [seconds].
  final TextEditingController seconds;
}

class DurationField extends StatelessWidget {
  /// The duration field widget can be used to display time.
  const DurationField({
    super.key,
    required this.controller,
  });

  /// The [controller] that handles the state of this widget.
  final DurationController controller;

  Widget buildField(TextEditingController textController) {
    return SizedBox(
      width: 90,
      child: TextFormField(
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.number,
        controller: textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildField(controller.hours),
        const SizedBox(width: 10),
        const HeadingText(':'),
        const SizedBox(width: 10),
        buildField(controller.minutes),
        const SizedBox(width: 10),
        const HeadingText(':'),
        const SizedBox(width: 10),
        buildField(controller.seconds),
        const SizedBox(width: 10),
        const Text(
          'DURATION',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
