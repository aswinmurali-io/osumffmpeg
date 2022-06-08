// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osumffmpeg/components/theme_button.dart';
import 'package:osumffmpeg/routes/convert_media.dart';

import '../routes/loop_video.dart';

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

  Widget get page {
    return FadeInRight(
      duration: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [ThemeButton(), content],
        ),
      ),
    );
  }

  @override
  String toString() => 'Route(title: $title, page: $content)';
}

class RouteProvider extends StateNotifier<int> {
  RouteProvider() : super(0);

  // ignore: avoid_setters_without_getters
  set route(final int index) => state = index;

  static final provider = StateNotifierProvider<RouteProvider, int>(
    (final ref) => RouteProvider(),
  );

  static final routes = [
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
      content: LoopVideoPage(),
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
}
