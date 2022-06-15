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
