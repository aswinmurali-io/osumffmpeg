// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osumlog/osumlog.dart';

import 'layout.dart';
import 'models/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Window.initialize();
  } on MissingPluginException catch (error) {
    Log.warn(error);
  }

  runApp(const ProviderScope(child: OsumFfmpeg()));
}

class OsumFfmpeg extends ConsumerWidget {
  const OsumFfmpeg({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(ThemeProvider.provider);
    ref.watch(ThemeProvider.provider.notifier).loadThemePreference();

    return MaterialApp(
      title: 'Osum FFMPEG',
      theme: ThemeProvider.lightTheme,
      darkTheme: ThemeProvider.darkTheme,
      themeMode: themeMode,
      // debugShowCheckedModeBanner: false,
      home: OsumLayout(themeMode: themeMode),
    );
  }
}
