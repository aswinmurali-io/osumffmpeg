import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:osumffmpeg/engine/enums/exec.dart';
import 'package:osumffmpeg/engine/enums/formats.dart';
import 'package:osumffmpeg/engine/errors.dart';
import 'package:osumffmpeg/engine/exec.dart';
import 'package:osumffmpeg/engine/media.dart';
import 'package:osumlog/osumlog.dart';

final testVideoDetails = {
  'path': File('test/video.mp4'),
};

class VideoTestDetails {
  static final file = File('test/video.mp4');

  static const duration = Duration(minutes: 3, seconds: 56);

  static const totalFrames = 9900;
}

void main() {
  group('(Media Engine)', () {
    test(
      'Check for ffmpeg binaries in this system.',
      () async => expect(await MediaEngine.checkForExecs(), equals('Success')),
    );

    test(
      'Check total video frames logic ${VideoTestDetails.file.path} '
      'should be ${VideoTestDetails.totalFrames}',
      () async => expect(
        await Media(VideoTestDetails.file).getTotalFrames(),
        equals(9900),
      ),
    );

    test(
      'Check duration logic ${VideoTestDetails.file.path} '
      'should be ${VideoTestDetails.duration}',
      () async {
        expect(
          await Media(VideoTestDetails.file).getDuration(),
          VideoTestDetails.duration,
        );
      },
    );

    test(
        'Check ffmpeg -v should cause exception because it does not exist. '
        'If it does exist then this ffmpeg version is different from the '
        'tested version for osumffmpeg.', () async {
      expect(
        () async => MediaEngine.executeFFmpeg(
          executable: FFmpegExec.ffmpeg,
          commands: ['-v'],
        ),
        throwsA(isA<MediaEngineException>()),
      );
    });

    Log.info('Possible media formats ${MediaFormats.values}');
  });
}
