import 'dart:io';

import 'package:async/async.dart';
import 'package:osumffmpeg/engine/except.dart';
import 'package:osumlog/osumlog.dart';

enum FFmpegExec {
  ffplay('ffplay'),
  ffmpeg('ffmpeg'),
  ffprobe('ffprobe');

  const FFmpegExec(this.value);
  final String value;
}

class MediaEngine {
  static Future<String> checkForExecs() async {
    for (final exec in FFmpegExec.values) {
      try {
        final response = await Process.run(exec.value, []);

        Log.info('${exec.value} returned ${response.exitCode}');
      } catch (e) {
        return 'Unable to find ${exec.value} executable which is part of the '
            'ffmpeg project. Please download it from https://ffmpeg.org/';
      }
    }

    return 'Success';
  }

  /// Execute [commands] inside ffmpeg's [executable] and get the output
  /// as a [Stream].
  static Future<Stream<List<int>>> executeFFmpegStream({
    required final FFmpegExec executable,
    required final List<String> commands,
  }) async {
    final process = await Process.run(executable.value, commands);

    return StreamGroup.merge([
      process.stderr as Stream<List<int>>,
      process.stdout as Stream<List<int>>
    ]).asBroadcastStream();
  }

  /// Execute [commands] inside ffmpeg's [executable] and get the output
  /// as a [String].
  static Future<String> executeFFmpeg({
    required final FFmpegExec executable,
    required final List<String> commands,
  }) async {
    final process = await Process.run(executable.value, commands);

    if (process.exitCode == 1) {
      throw MediaEngineException(process.stderr);
    }
    return '${process.stdout}';
  }
}
