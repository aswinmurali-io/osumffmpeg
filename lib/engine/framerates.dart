// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'errors.dart';
import 'utils.dart';

class MediaFrameRateFormat implements WithDisplayString {
  const MediaFrameRateFormat(this.frameRateString, this.frameRate);

  factory MediaFrameRateFormat.fromString(String framerate) {
    final value = double.tryParse(framerate);

    if (framerate.isNotEmpty && value != null) {
      return MediaFrameRateFormat('Custom', value);
    } else {
      throw InvalidMediaFormat(framerate);
    }
  }

  final String frameRateString;

  final double frameRate;

  @override
  String toDisplayString() => '$frameRate';

  @override
  String toString() => frameRateString;
}

enum MediaFrameRateFormats implements WithDisplayableValue {
  f29(MediaFrameRateFormat('29 Frames / Second', 29)),
  f24(MediaFrameRateFormat('24 Frames / Second', 24)),
  f30(MediaFrameRateFormat('30 Frames / Second', 30)),
  f59(MediaFrameRateFormat('59 Frames / Second', 59)),
  f60(MediaFrameRateFormat('60 Frames / Second', 60)),
  f90(MediaFrameRateFormat('90 Frames / Second', 90));

  const MediaFrameRateFormats(this.value);

  @override
  final MediaFrameRateFormat value;
}
