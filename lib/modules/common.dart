import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osumlog/osumlog.dart';

class FFmpegStatusStreamProvider
    extends StateNotifier<StreamBuilder<List<int>>?> {
  FFmpegStatusStreamProvider() : super(null);

  static final provider = StateNotifierProvider<FFmpegStatusStreamProvider,
      StreamBuilder<List<int>>?>(
    (final ref) => FFmpegStatusStreamProvider(),
  );

  static const ffmpeg = 'ffmpeg';

  Future<void> sendToFFmpeg(final List<String> commands) async {
    Log.info('$ffmpeg ${commands.join(' ')}');

    final process = await Process.start(ffmpeg, commands);

    state = StreamBuilder<List<int>>(
      initialData: const [0],
      stream: StreamGroup.merge([process.stdout, process.stderr]),
      builder: (final context, final snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Text(String.fromCharCodes(snapshot.data!));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
