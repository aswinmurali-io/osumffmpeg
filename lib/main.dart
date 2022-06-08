// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'layout.dart';
import 'models/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  runApp(ProviderScope(child: const OsumFfmpeg()));
}

class OsumFfmpeg extends ConsumerWidget {
  const OsumFfmpeg({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final themeMode = ref.watch(ThemeProvider.provider);

    Window.setEffect(
      effect: WindowEffect.mica,
      dark: themeMode == ThemeMode.dark,
    );

    return MaterialApp(
      title: 'Osum ffmpeg',
      theme: ThemeProvider.lightTheme ,
      darkTheme: ThemeProvider.darkTheme,
      themeMode: themeMode,
      home: OsumMainPage(),
    );
  }
}
