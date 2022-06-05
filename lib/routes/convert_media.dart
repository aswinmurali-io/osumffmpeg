import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osumffmpeg/components/theme_button.dart';

class ConvertMediaPage extends ConsumerWidget {
  const ConvertMediaPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Row(
          children: const [
            ThemeButton(),
          ],
        ),
      ),
    );
  }
}
