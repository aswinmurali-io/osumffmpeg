import '../utils.dart';

class MediaFormat implements WithDisplayString {
  const MediaFormat(this.formatString, this.displayString);

  factory MediaFormat.fromDisplayString(String formatString) => MediaFormat(
        MediaFormats.values
            .where((format) => format.value.formatString == formatString)
            .first
            .value
            .formatString,
        formatString,
      );

  final String formatString;

  final String displayString;

  @override
  String toDisplayString() => displayString;

  @override
  String toString() => formatString;
}

enum MediaFormats implements WithDisplayableValue {
  mkv(MediaFormat('Matroska Multimedia Container', 'mkv')),
  mp3(MediaFormat('MPEG-2 Audio Layer III', 'mp3')),
  mp4(MediaFormat('MPEG-4 Part 14', 'mp4')),
  mov(MediaFormat('QuickTime File Format', 'mov')),
  avi(MediaFormat('Audio Video Interleave', 'avi')),
  mk4(MediaFormat('MPEG-4 Video', 'm4v'));

  const MediaFormats(this.value);

  @override
  final MediaFormat value;
}
