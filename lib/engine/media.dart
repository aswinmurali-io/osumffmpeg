import 'dart:io';

import 'exec.dart';

enum MediaFormats {
  mkv('mkv'),
  mp3('mp3'),
  mp4('mp4'),
  mov('mov'),
  avi('avi'),
  mk4('m4v');

  const MediaFormats(this.value);
  final String value;
}

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
      commands: [
        '-i',
        media.absolute.path,
        outputFile.path,
        '-y'
      ],
    );
  }

  /// Loop and save as [outputFile] video with specific [duration].
  Future<void> loopAndSave(
    final File outputFile,
    final Duration duration,
  ) async {
    await MediaEngine.executeFFmpeg(
      executable: FFmpegExec.ffmpeg,
      commands: [
        '-re',
        '-f',
        'lavfi',
        '-i',
        '"movie=filename=${media.path}:loop=0, setpts=N/(FRAME_RATE*TB)"',
        '-t',
        '${duration.inSeconds}',
        outputFile.path,
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
}
