import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osumffmpeg/routes/convert_media.dart';

@immutable
class Route {
  const Route({
    required this.title,
    required this.icon,
    required this.content,
  });

  final String title;

  final Icon icon;

  final Widget content;

  Widget get page => FadeInLeft(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: content,
        ),
      );

  @override
  String toString() => 'Route(title: $title, page: $content)';
}

class RoutesValueNotifier extends StateNotifier<List<Route>> {
  RoutesValueNotifier() : super([]);

  bool isBuildOnce = false;

  Future<bool> add() async {
    if (!isBuildOnce) {
      await Future.delayed(const Duration(milliseconds: 1));

      super.state = [
        ...super.state,
        Route(
          title: 'Convert Media',
          icon: const Icon(Icons.update),
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
        Route(
          title: 'Loop video',
          icon: const Icon(Icons.repeat),
          content: Container(),
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
      isBuildOnce = true;
    }
    return isBuildOnce;
  }
}

final routeProvider = StateNotifierProvider<RoutesValueNotifier, List<Route>>(
  (final ref) => RoutesValueNotifier(),
);
