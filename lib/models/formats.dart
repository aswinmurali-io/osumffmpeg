import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MediaFormats {
  mkv('mkv'),
  mp3('mp3'),
  mp4('mp4'),
  mov('mov'),
  avi('avi'),
  mk4('m4v');

  const MediaFormats(this.value);
  final String value;
}

class MediaFormatProvider extends StateNotifier<MediaFormats> {
  MediaFormatProvider() : super(MediaFormats.mk4);

  static final provider =
      StateNotifierProvider<MediaFormatProvider, MediaFormats>(
    (final ref) {
      return MediaFormatProvider();
    },
  );

  // ignore: avoid_setters_without_getters
  set format(final MediaFormats format) => state = format;
}
