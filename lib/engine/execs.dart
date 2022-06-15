import 'utils.dart';

enum FFmpegExec implements WithValue<String> {
  ffplay('ffplay'),
  ffmpeg('ffmpeg'),
  ffprobe('ffprobe');

  const FFmpegExec(this.value);

  @override
  final String value;
}
