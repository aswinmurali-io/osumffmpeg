import 'dart:io';

import 'execs.dart';
import 'resolutions.dart';
import 'core.dart';

class Media {
  const Media(this.media);

  /// The media file.
  final File media;

  /// Save the media in a specific [format] as [outputFile].
  Future<Stream<List<int>>> saveToFormat(File outputFile) async {
    return MediaEngine.executeFFmpegStream(
      executable: FFmpegExec.ffmpeg,
      commands: ['-i', media.absolute.path, outputFile.path, '-y'],
    );
  }

  /// Loop and save as [outputFile] video with specific [duration].
  Future<Stream<List<int>>> loopAndSave(
    File outputFile,
    Duration duration,
  ) async {
    // ffmpeg requires posix-style path passed inside string quotes for
    // input media file.
    final posixPath = media.path.replaceAll(r'\', '/');

    return MediaEngine.executeFFmpegStream(
      executable: FFmpegExec.ffmpeg,
      commands: [
        '-re',
        '-f',
        'lavfi',
        '-i',
        "movie=filename=\\'$posixPath\\':loop=0, setpts=N/(FRAME_RATE*TB)",
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

  Future<Stream<List<int>>> scaleVideo(
    MediaResolution resolution,
    File outputFile,
  ) async {
    return MediaEngine.executeFFmpegStream(
      executable: FFmpegExec.ffmpeg,
      commands: [
        '-i',
        media.path,
        '-vf',
        'scale=${resolution.toDisplayString()}:flags=lanczos',
        outputFile.path,
        '-y',
      ],
    );
  }
}
