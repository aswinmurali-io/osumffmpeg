// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'errors.dart';
import 'utils.dart';

class OsumResolution implements WithDisplayString {
  /// Define a media resolution by giving it's [width], [height]
  /// and a [name] to identify it.
  const OsumResolution(this.width, this.height, this.name);

  factory OsumResolution.fromString(String resolution) {
    // Must have the 'x' character and also atleast one digit after that.
    if (resolution.contains('x') &&
        (resolution.indexOf('x') + 1) < resolution.length) {
      final units = resolution.split('x').map(int.parse);
      return OsumResolution(units.first, units.last, 'Custom');
    } else {
      throw InvalidMediaResolution(resolution);
    }
  }

  final int width;

  final int height;

  final String name;

  @override
  String toString() => '$name ($width x $height)';

  @override
  String toDisplayString() => '${width}x$height';
}

/// Common media resolutions.
///
/// source:
///   1. https://en.wikipedia.org/wiki/Display_resolution
///   2. Samsung display settings.
enum OsumResolutions implements WithDisplayableValue {
  hd720(OsumResolution(1280, 720, 'HD 720')),
  hdplus(OsumResolution(1600, 720, 'HD+ 720')),
  fhd1080(OsumResolution(1920, 1080, 'FHD 1080')),
  fhdplus1080(OsumResolution(2400, 1080, 'FHD+ 1080')),
  wqhd2kplus(OsumResolution(3200, 1440, 'WQHD+ 2K')),
  uhd4k(OsumResolution(3840, 2160, 'UHD 4K')),
  uhd8k(OsumResolution(7680, 4320, 'UHD 8K'));

  const OsumResolutions(this.value);

  @override
  final OsumResolution value;
}
