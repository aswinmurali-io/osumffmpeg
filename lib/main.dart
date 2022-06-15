import 'package:flutter/material.dart' hide Route;
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/route_navigations.dart';
import 'components/work_in_progress.dart';
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
    const Route(
      title: 'Convert Media',
      icon: Icon(Icons.update),
      content: ConvertMediaPage(),
      description: 'Convert video/audio from one format to another.',
    ),
    const Route(
      title: 'Save photo from video',
      icon: Icon(Icons.photo),
      content: WorkInProgress(),
      description: '',
    ),
    const Route(
      title: 'Upscale or downscale video',
      icon: Icon(Icons.screenshot_monitor),
      content: ScaleVideoPage(),
      description:
          'Upscale video resolution from 1080p to 4K or downscale to 480p.',
    ),
    const Route(
      title: 'Change framerate of video',
      icon: Icon(Icons.speed),
      content: WorkInProgress(),
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
    const Route(
      title: 'Change or mute audio in video',
      icon: Icon(Icons.audiotrack),
      content: WorkInProgress(),
      description: '',
    ),
    const Route(
      title: 'Make gif from video',
      icon: Icon(Icons.gif),
      content: WorkInProgress(),
      description: '',
    ),
    const Route(
      title: 'Make video from images',
      icon: Icon(Icons.video_camera_front),
      content: WorkInProgress(),
      description: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: Check performance effects of window theme refreshing when
    // rebuilding the main app layout. This should only happen when system
    // theme changes or changing routes (need to avoid changing route rebuild).
    ThemeProvider.refreshWindowTheme(themeMode);

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
