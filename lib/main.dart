// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osumffmpeg/models/routes.dart';

import 'models/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  await DesktopWindow.setWindowSize(Size(1000, 700));
  await Window.setEffect(
    effect: WindowEffect.mica,
    color: Colors.transparent,
    dark: false,
  );

  runApp(ProviderScope(child: const OsumFfmpeg()));
}

class OsumMainPage extends ConsumerWidget {
  const OsumMainPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final routes = ref.watch(routeProvider);
    final routesNotifier = ref.watch(routeProvider.notifier);

    return Scaffold(
      body: Row(
        children: [
          FutureBuilder(
            future: routesNotifier.add(),
            builder: (final context, final snapshot) {
              const width = 120.0;
              if (!snapshot.hasData) {
                return SizedBox(
                  width: width,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return SizedBox(
                  width: width,
                  child: FadeInLeftBig(
                    duration: const Duration(milliseconds: 200),
                    // NavigationRail scrollable support.
                    // NOTE: https://github.com/flutter/flutter/issues/89167
                    // IntrinsicHeight <- is expensive.
                    child: LayoutBuilder(
                      builder: (final context, final constraint) {
                        return Scrollbar(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraint.maxHeight,
                              ),
                              child: IntrinsicHeight(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 5, 10, 5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: NavigationRail(
                                      labelType: NavigationRailLabelType.all,
                                      destinations: [
                                        for (final route in routes)
                                          NavigationRailDestination(
                                            icon: ZoomIn(child: route.icon),
                                            label: Text(
                                              route.title,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                      ],
                                      selectedIndex: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
          // VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Center(
              child: Text('selectedIndex: 0'),
            ),
          )
        ],
      ),
    );
  }
}

class OsumFfmpeg extends ConsumerWidget {
  const OsumFfmpeg({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final themeMode = ref.watch(ThemeState.provider);

    return MaterialApp(
      title: 'Osum ffmpeg',
      theme: ThemeState.lightTheme,
      darkTheme: ThemeState.darkTheme,
      themeMode: themeMode,
      home: OsumMainPage(),
    );
  }
}
