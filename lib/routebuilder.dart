///
/// ```bash
/// $ ffmpeg -i input.mp3 output.mov
/// ```
/// ```yaml
/// name: 'Convert Media'
/// icon: Icons.update
/// page:
///   input:
///     filebrowser:
///       extensions:
///         - mp4
///         - mov
///         ...
///   format:
///     dropdown:
///       text: 'Output video format.'
///       default: mp4
///       values:
///         - mp4
///         - mov
///         - ...
///   output:
///     filebrowser:
///       defaultPath: 'auto'
///       filename: '{%INPUT_FILENAME_WITH_NO_EXTENSION}'
/// ```
class RouteBuilder {
  const RouteBuilder();
}
