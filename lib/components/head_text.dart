import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  const HeadingText(this.data, {super.key});

  final String data;

  @override
  Widget build(final BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.headline2,
    );
  }
}
