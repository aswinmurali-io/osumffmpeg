import 'dart:io';

import 'enums/exec.dart';
import 'enums/formats.dart';
import 'enums/resolution.dart';
import 'exec.dart';

class Media {
  const Media(this.media);

  /// The media file.
  final File media;

  /// Save the media in a specific [format] as [outputFile].
  Future<Stream<List<int>>> saveToFormat(
    final MediaFormats format,
    final File outputFile,
  ) async {
    return MediaEngine.executeFFmpegStream(
      executable: FFmpegExec.ffmpeg,
      commands: ['-i', media.absolute.path, outputFile.path, '-y'],
    );
  }

  /// Loop and save as [outputFile] video with specific [duration].
  Future<Stream<List<int>>> loopAndSave(
    final File outputFile,
    final Duration duration,
  ) async {
    return MediaEngine.executeFFmpegStream(
      executable: FFmpegExec.ffmpeg,
      commands: [
        '-re',
        '-i',
        media.path,
        '-t',
        '${duration.inSeconds}',
        outputFile.path,
        '-y',
      ],
    );
  }

  /// Get the total frames in the video.
  Future<int> getTotalFrames() async {
    return int.parse(
      await MediaEngine.executeFFmpeg(
        executable: FFmpegExec.ffprobe,
        commands: [
          '-v',
          'error',
          '-select_streams',
          'v:0',
          '-count_packets',
          '-show_entries',
          'stream=nb_read_packets',
          '-of',
          'csv=p=0',
          media.absolute.path
        ],
      ),
    );
  }

  // Get duration of media.
  Future<Duration> getDuration() async {
    final response = await MediaEngine.executeFFmpeg(
      executable: FFmpegExec.ffprobe,
      commands: [
        '-v',
        'error',
        '-show_entries',
        'format=duration',
        '-of',
        'default=noprint_wrappers=1:nokey=1',
        media.absolute.path,
        '-sexagesimal',
      ],
    );

    final unitTime = response.split(':');

    final finalUnitTime = unitTime.last.split('.');

    // h:mm:ss.mmmmmm <- format
    return Duration(
      hours: int.parse(unitTime[0]),
      minutes: int.parse(unitTime[1]),
      seconds: int.parse(finalUnitTime[0]),
      milliseconds: int.parse(finalUnitTime[1]),
    );
  }

  Future<Stream<List<int>>> scale(
    final MediaResolution resolution,
    final File outputFile,
  ) async {
    return MediaEngine.executeFFmpegStream(
      executable: FFmpegExec.ffmpeg,
      commands: [
        '-i',
        media.path,
        '-vf',
        'scale=$resolution:flags=lanczos',
        outputFile.path,
        '-y',
      ],
    );
  }
}
