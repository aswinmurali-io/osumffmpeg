import 'package:flutter/material.dart' hide Route;
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/route_navigations.dart';
import 'models/route.dart';
import 'models/theme.dart';
import 'routes/convert_media.dart';
import 'routes/loop_video.dart';
import 'routes/scale_video.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  runApp(const ProviderScope(child: OsumFfmpeg()));
}

class OsumFfmpeg extends ConsumerWidget {
  const OsumFfmpeg({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(ThemeProvider.provider);

    if (themeMode == ThemeMode.dark) {
      Window.setEffect(effect: WindowEffect.acrylic, dark: true);
    } else {
      Window.setEffect(effect: WindowEffect.mica, dark: false);
    }

    return MaterialApp(
      title: 'Osum FFMPEG',
      theme: ThemeProvider.lightTheme,
      darkTheme: ThemeProvider.darkTheme,
      themeMode: themeMode,
      // debugShowCheckedModeBanner: false,
      home: const OsumLayout(),
    );
  }
}

class OsumLayout extends HookWidget {
  const OsumLayout({super.key});

  static final routeJumpController = TextEditingController();

  static final routes = [
    const Route(
      title: 'Convert Media',
      icon: Icon(Icons.update),
      content: ConvertMediaPage(),
      description: 'Convert video/audio from one format to another.',
    ),
    Route(
      title: 'Save photo from video',
      icon: const Icon(Icons.photo),
      content: Container(),
      description: '',
    ),
    const Route(
      title: 'Upscale or downscale video',
      icon: Icon(Icons.screenshot_monitor),
      content: ScaleVideoPage(),
      description:
          'Upscale video resolution from 1080p to 4K or downscale to 480p.',
    ),
    Route(
      title: 'Change framerate of video',
      icon: const Icon(Icons.speed),
      content: Container(),
      description:
          'Make video smoother or slower by changing framerate of video.',
    ),
    const Route(
      title: 'Loop video',
      icon: Icon(Icons.repeat),
      content: LoopMediaPage(),
      description:
          'Repeat the contents inside a video upto a certain duration.',
    ),
    Route(
      title: 'Change or mute audio in video',
      icon: const Icon(Icons.audiotrack),
      content: Container(),
      description: '',
    ),
    Route(
      title: 'Make gif from video',
      icon: const Icon(Icons.gif),
      content: Container(),
      description: '',
    ),
    Route(
      title: 'Make video from images',
      icon: const Icon(Icons.video_camera_front),
      content: Container(),
      description: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final routeIndex = useState(0);

    return Scaffold(
      body: Row(
        children: [
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
    );
  }
}
