class MediaEngineException implements Exception {
  MediaEngineException(this.error);

  final dynamic error;

  @override
  String toString() => '(ffmpeg error) $error';
}
