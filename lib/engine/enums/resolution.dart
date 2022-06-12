import '../utils.dart';

class MediaResolution implements WithDisplayString {
  /// Define a media resolution by giving it's [width], [height]
  /// and a [name] to identify it.
  const MediaResolution(this.width, this.height, this.name);

  final int width;

  final int height;

  final String name;

  @override
  String toString() => '${width}x$height';

  @override
  String toDisplayString() => '$name ($width x $height)';
}

/// Common media resolutions.
///
/// source:
///   1. https://en.wikipedia.org/wiki/Display_resolution
///   2. Samsung display settings.
enum MediaResolutions implements WithDisplayableValue {
  hd720(MediaResolution(1280, 720, 'HD 720')),
  hdplus(MediaResolution(1600, 720, 'HD+ 720')),
  fhd1080(MediaResolution(1920, 1080, 'FHD 1080')),
  fhdplus1080(MediaResolution(2400, 1080, 'FHD+ 1080')),
  wqhd2kplus(MediaResolution(3200, 1440, 'WQHD+ 2K')),
  uhd4k(MediaResolution(3840, 2160, 'UHD 4K')),
  uhd8k(MediaResolution(7680, 4320, 'UHD 8K'));

  const MediaResolutions(this.value);

  @override
  final MediaResolution value;
}