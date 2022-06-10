import 'package:flutter/material.dart' hide Route;
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/route_navigations.dart';
import 'models/route.dart';
import 'models/theme.dart';
import 'routes/convert_media.dart';
import 'routes/loop_video.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  runApp(const ProviderScope(child: OsumFfmpeg()));
}

class OsumFfmpeg extends ConsumerWidget {
  const OsumFfmpeg({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
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
      home: OsumLayout(),
    );
  }
}

class OsumLayout extends HookWidget {
  OsumLayout({super.key});

  final routes = [
    const Route(
      title: 'Convert Media',
      icon: Icon(Icons.update),
      content: ConvertMediaPage(),
    ),
    Route(
      title: 'Save photo from video',
      icon: const Icon(Icons.photo),
      content: Container(),
    ),
    Route(
      title: 'Upscale or downscale video',
      icon: const Icon(Icons.screenshot_monitor),
      content: Container(),
    ),
    Route(
      title: 'Change framerate of video',
      icon: const Icon(Icons.speed),
      content: Container(),
    ),
    const Route(
      title: 'Loop video',
      icon: Icon(Icons.repeat),
      content: LoopMediaPage(),
    ),
    Route(
      title: 'Change or mute audio in video',
      icon: const Icon(Icons.audiotrack),
      content: Container(),
    ),
    Route(
      title: 'Make gif from video',
      icon: const Icon(Icons.gif),
      content: Container(),
    ),
    Route(
      title: 'Make video from images',
      icon: const Icon(Icons.video_camera_front),
      content: Container(),
    ),
  ];

  @override
  Widget build(final BuildContext context) {
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
                    child: route.page,
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
