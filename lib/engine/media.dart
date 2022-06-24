// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'core.dart';
import 'errors.dart';
import 'execs.dart';
import 'framerates.dart';
import 'resolutions.dart';

class OsumMedia {
  const OsumMedia(this.media);

  /// The media file.
  final File media;

  /// Save the media in a specific [framerate] as [outputFile].
  Future<Stream<List<int>>> saveToFormat(
    File outputFile,
  ) async {
    return osumEngine.executeFFmpegStream(
      executable: OsumExecs.ffmpeg,
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

    return osumEngine.executeFFmpegStream(
      executable: OsumExecs.ffmpeg,
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
      await osumEngine.executeFFmpeg(
        executable: OsumExecs.ffprobe,
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
    final response = await osumEngine.executeFFmpeg(
      executable: OsumExecs.ffprobe,
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
    OsumResolution resolution,
    File outputFile,
  ) async {
    return osumEngine.executeFFmpegStream(
      executable: OsumExecs.ffmpeg,
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

  Future<Stream<List<int>>> changeFrameRate(
    OsumFrameRate frameRate,
    File outputFile,
  ) async {
    return osumEngine.executeFFmpegStream(
      executable: OsumExecs.ffmpeg,
      commands: [
        '-i',
        media.path,
        '-filter:v',
        'fps=fps=${frameRate.toDisplayString()}',
        outputFile.path,
        '-y',
      ],
    );
  }

  Future<MemoryImage> getFrame(Duration position) async {
    // Need to give image different id to update state.
    // Bitmap is the fastest way to save frame.

    final file = (Platform.isAndroid || Platform.isIOS)
        ? 'Osumffmpeg Frame.jpg'
        : 'Osumffmpeg Frame.bmp';

    await osumEngine.executeFFmpeg(
      executable: OsumExecs.ffmpeg,
      commands: [
        // To ignore audio processing, Can improve performance.
        '-an',
        /*
         Seek argument MUST be first. (Massive performance boost)
         Refer https://stackoverflow.com/questions/6984628/ffmpeg-ss-weird-behaviour 
         */
        '-ss',
        '${position.inSeconds}',
        '-i',
        media.path,
        '-frames:v',
        '1',
        file,
        '-y',
      ],
    );

    final thumbnail = File(file);

    if (await thumbnail.exists()) {
      final data = await thumbnail.readAsBytes();
      await thumbnail.delete();

      return MemoryImage(data);
    }
    throw const FailedToGetFrameFromMedia(null);
  }

  Future<void> saveFrame(Duration position, File output) async {
    final frame = await getFrame(position);

    await output.writeAsBytes(frame.bytes);
  }

  Future<Stream<List<int>>> saveAllFrames(
    Directory output,
    String format,
  ) async {
    final posixPath = output.path.replaceAll(r'\', '/');

    return osumEngine.executeFFmpegStream(
      executable: OsumExecs.ffmpeg,
      commands: [
        // To ignore audio processing, Can improve performance.
        '-an',
        '-i',
        media.path,
        join(
          posixPath,
          '${basenameWithoutExtension(media.path)}-%03d.$format',
        ),
        '-y',
      ],
    );
  }

  static const ffplayTitle = 'Osumffmpeg ffplay';

  Future<String> play() async {
    return osumEngine.executeFFmpeg(
      executable: OsumExecs.ffplay,
      commands: [
        media.path,
        '-window_title',
        ffplayTitle,
      ],
    );
  }
}
