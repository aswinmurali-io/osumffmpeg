// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'errors.dart';
import 'utils.dart';

class OsumFormat implements WithDisplayString {
  const OsumFormat(this.formatString, this.displayString);

  factory OsumFormat.fromString(String format) {
    if (format.isNotEmpty) {
      return OsumFormat('Custom', format);
    } else {
      throw InvalidMediaFormat(format);
    }
  }

  final String formatString;

  final String displayString;

  @override
  String toDisplayString() => displayString;

  @override
  String toString() => formatString;
}

enum OsumFormats implements WithDisplayableValue {
  mkv(OsumFormat('Matroska Multimedia Container', 'mkv')),
  mp3(OsumFormat('MPEG-2 Audio Layer III', 'mp3')),
  mp4(OsumFormat('MPEG-4 Part 14', 'mp4')),
  mov(OsumFormat('QuickTime File Format', 'mov')),
  avi(OsumFormat('Audio Video Interleave', 'avi')),
  mk4(OsumFormat('MPEG-4 Video', 'm4v'));

  const OsumFormats(this.value);

  @override
  final OsumFormat value;
}
