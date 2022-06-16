// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

class MediaEngineException implements Exception {
  const MediaEngineException(this.error);

  final dynamic error;

  @override
  String toString() => '(ffmpeg error) $error';
}

class InvalidMediaResolution implements Exception {
  const InvalidMediaResolution(this.resolution);

  final dynamic resolution;

  @override
  String toString() => '(invalid resolution error) $resolution';
}

class InvalidMediaFormat implements Exception {
  const InvalidMediaFormat(this.format);

  final dynamic format;

  @override
  String toString() => '(invalid format error) $format';
}

class FailedToGetFrameFromMedia implements Exception {
  const FailedToGetFrameFromMedia(this.reason);

  final dynamic reason;

  @override
  String toString() => '(failed to extract frame) $reason';
}
