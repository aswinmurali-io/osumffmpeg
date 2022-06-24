// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:osumffmpeg/engine/core.dart';
import 'package:osumffmpeg/engine/errors.dart';
import 'package:osumffmpeg/engine/execs.dart';
import 'package:osumffmpeg/engine/formats.dart';
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
      () async => expect(await osumEngine.checkForExecs(), equals('Success')),
    );

    test(
      'Check total video frames logic ${VideoTestDetails.file.path} '
      'should be ${VideoTestDetails.totalFrames}',
      () async => expect(
        await OsumMedia(VideoTestDetails.file).getTotalFrames(),
        equals(9900),
      ),
    );

    test(
      'Check duration logic ${VideoTestDetails.file.path} '
      'should be ${VideoTestDetails.duration}',
      () async {
        expect(
          await OsumMedia(VideoTestDetails.file).getDuration(),
          VideoTestDetails.duration,
        );
      },
    );

    test(
        'Check ffmpeg -v should cause exception because it does not exist. '
        'If it does exist then this ffmpeg version is different from the '
        'tested version for osumffmpeg.', () async {
      expect(
        () async => osumEngine.executeFFmpeg(
          executable: OsumExecs.ffmpeg,
          commands: ['-v'],
        ),
        throwsA(isA<OsumEngineException>()),
      );
    });

    Log.info('Possible media formats ${OsumFormats.values}');
  });
}
