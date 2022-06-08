import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osumffmpeg/engine/exec.dart';
import 'package:osumlog/osumlog.dart';

class FFmpegProvider extends StateNotifier<StreamBuilder<List<int>>?> {
  FFmpegProvider() : super(null);

  static final provider =
      StateNotifierProvider<FFmpegProvider, StreamBuilder<List<int>>?>(
    (final ref) => FFmpegProvider(),
  );

  static const ffmpeg = 'ffmpeg';

  Future<void> sendToFFmpeg(final List<String> commands) async {
    Log.info('$ffmpeg ${commands.join(' ')}');

    state = StreamBuilder<List<int>>(
      initialData: const [0],
      stream: await MediaEngine.executeFFmpegStream(
        executable: FFmpegExec.ffmpeg,
        commands: commands,
      ),
      builder: (final context, final snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Text(
            String.fromCharCodes(snapshot.data!),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
