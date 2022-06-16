// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osumlog/osumlog.dart';

import 'components/route_navigations.dart';
import 'components/work_in_progress.dart';
import 'models/route.dart';
import 'models/theme.dart';
import 'routes/change_framerate.dart';
import 'routes/convert_media.dart';
import 'routes/loop_video.dart';
import 'routes/save_photo_from_video.dart';
import 'routes/scale_video.dart';

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

class OsumLayout extends HookWidget {
  const OsumLayout({super.key, required this.themeMode});

  final ThemeMode themeMode;

  static final routeJumpController = TextEditingController();

  static final routes = [
    Route(
      title: 'Convert Media',
      icon: const Icon(Icons.update),
      content: const ConvertMediaPage(),
      description:
          'Convert video/audio from the current format to a different one.',
    ),
    Route(
      title: 'Save photo from video',
      icon: const Icon(Icons.photo),
      content: const SavePhotoFromVideoPage(),
      description:
          'Extract & save a particular frame or multiple frames from the video and save it.',
    ),
    Route(
      title: 'Upscale or downscale video',
      icon: const Icon(Icons.screenshot_monitor),
      content: const ScaleVideoPage(),
      description:
          'Upscale video resolution from 1080p to 4K or downscale to 480p.',
    ),
    Route(
      title: 'Change framerate of video',
      icon: const Icon(Icons.speed),
      content: const ChangeFrameRatePage(),
      description:
          'Make video smoother or slower by changing framerate of video.',
    ),
    Route(
      title: 'Loop video',
      icon: const Icon(Icons.repeat),
      content: const LoopMediaPage(),
      description:
          'Repeat the contents inside a video upto a certain duration.',
    ),
    Route(
      title: 'Change or mute audio in video',
      icon: const Icon(Icons.audiotrack),
      content: const WorkInProgress(),
      description: 'Add / Change / Mute multiple audio tracks in a video.',
    ),
    Route(
      title: 'Make gif from video',
      icon: const Icon(Icons.gif),
      content: const WorkInProgress(),
      description:
          'Convert a video into an animated gif. Audio will be lost in the gif.',
    ),
    Route(
      title: 'Make video from images',
      icon: const Icon(Icons.video_camera_front),
      content: const WorkInProgress(),
      description: 'Convert multiple images into a video.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: Check performance effects of window theme refreshing when
    // rebuilding the main app layout. This should only happen when system
    // theme changes or changing routes (need to avoid changing route rebuild).
    ThemeProvider.refreshWindowTheme(themeMode);

    final routeIndex = useState(0);

    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            if (!Platform.isAndroid && !Platform.isIOS)
              RouteNavigationRail(
                routes: routes,
                index: routeIndex,
              ),
            Expanded(
              child: Stack(
                children: [
                  for (final route in routes)
                    Visibility(
                      maintainState: true,
                      visible: route == routes[routeIndex.value],
                      child: route.page(context, routeIndex),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
