import '../utils.dart';

enum MediaFormats implements WithValue<String> {
  mkv('mkv'),
  mp3('mp3'),
  mp4('mp4'),
  mov('mov'),
  avi('avi'),
  mk4('m4v');

  const MediaFormats(this.value);

  @override
  final String value;
}
