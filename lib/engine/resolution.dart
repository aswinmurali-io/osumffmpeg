class Resolution {
  /// Define a media resolution by giving it's [width], [height]
  /// and a [name] to identify it.
  const Resolution(this.width, this.height, this.name);

  final int width;

  final int height;

  final String name;

  @override
  String toString() => '${width}x$height';

  String toDisplayString() => '$name ($width x $height)';
}

/// Common media resolutions.
///
/// source:
///   1. https://en.wikipedia.org/wiki/Display_resolution
///   2. Samsung display settings.
enum Resolutions {
  hd720(Resolution(1280, 720, 'HD 720')),
  hdplus(Resolution(1600, 720, 'HD+ 720')),
  fhd1080(Resolution(1920, 1080, 'FHD 1080')),
  fhdplus1080(Resolution(2400, 1080, 'FHD+ 1080')),
  wqhd2kplus(Resolution(3200, 1440, 'WQHD+ 2K')),
  uhd4k(Resolution(3840, 2160, 'UHD 4K')),
  uhd8k(Resolution(7680, 4320, 'UHD 8K'));

  const Resolutions(this.value);

  final Resolution value;
}
