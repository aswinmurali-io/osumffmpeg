// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'utils.dart';

enum OsumExecs implements WithValue<String> {
  ffplay('ffplay'),
  ffmpeg('ffmpeg'),
  ffprobe('ffprobe');

  const OsumExecs(this.value);

  @override
  final String value;
}
