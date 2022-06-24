// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'errors.dart';
import 'utils.dart';

class OsumFrameRate implements WithDisplayString {
  const OsumFrameRate(this.frameRateString, this.frameRate);

  factory OsumFrameRate.fromString(String framerate) {
    final value = double.tryParse(framerate);

    if (framerate.isNotEmpty && value != null) {
      return OsumFrameRate('Custom', value);
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

enum OsumFrameRates implements WithDisplayableValue {
  f29(OsumFrameRate('29 Frames / Second', 29)),
  f24(OsumFrameRate('24 Frames / Second', 24)),
  f30(OsumFrameRate('30 Frames / Second', 30)),
  f59(OsumFrameRate('59 Frames / Second', 59)),
  f60(OsumFrameRate('60 Frames / Second', 60)),
  f90(OsumFrameRate('90 Frames / Second', 90));

  const OsumFrameRates(this.value);

  @override
  final OsumFrameRate value;
}
