import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:osumffmpeg/engine/exec.dart';

import 'package:path/path.dart';

import '../components/custom_button.dart';
import '../components/duration_field.dart';
import '../components/head_text.dart';
import '../engine/media.dart';

class _PageState {
  /// The loop media page state.
  _PageState()
      : input = useTextEditingController(),
        output = useTextEditingController(),
        duration = DurationController(),
        enableLoop = useState(false),
        ffmpegOutput = useState(null);

  /// The [input] media file text field controller.
  final TextEditingController input;

  /// The [output] looped media file text field controller.
  final TextEditingController output;

  /// The [duration] of the looped media file.
  final DurationController duration;

  /// Should the loop button be enabled.
  final ValueNotifier<bool> enableLoop;

  /// The
  final ValueNotifier<Stream<List<int>>?> ffmpegOutput;

  /// Get the default output file location based on the [input] given.
  ///
  /// Example
  ///   `C:\Users\User\Desktop\sample.mp3` becomes -->
  ///   `C:\Users\User\Desktop\sample_looped.mp3`
  String getDefaultOutputFileLocation() {
    final path = dirname(input.text);
    final filename = basenameWithoutExtension(input.text);
    final ext = extension(input.text);

    return '$path/${filename}_looped$ext';
  }

  /// On browsing the input file to loop.
  Future<void> onBrowseInputFile() async {
    final file = await FilePicker.platform.saveFile(
      dialogTitle: 'Pick input media file.',
    );

    if (file != null) {
      input.text = file;

      final totalDuration = await Media(File(file)).getDuration();

      duration.hours.text = '${totalDuration.inHours.remainder(24)}';
      duration.minutes.text = '${totalDuration.inMinutes.remainder(60)}';
      duration.seconds.text = '${totalDuration.inSeconds.remainder(60)}';

      output.text = getDefaultOutputFileLocation();
    }
  }

  /// On saving looped output media file.
  Future<void> onBrowseOutputFile() async {
    late String? file;

    if (await File(output.text).exists()) {
      file = await FilePicker.platform.saveFile(
        dialogTitle: 'Pick output media file.',
        initialDirectory: dirname(output.text),
      );
    } else {
      file = await FilePicker.platform.saveFile(
        dialogTitle: 'Pick output media file.',
      );
    }

    if (file != null) {
      output.text = file;
    }
  }

  /// Checking if the form is valid to enable loop button.
  Future<void> onChangeInForm() async {
    if (await File(input.text).exists() &&
        await Directory(dirname(input.text)).exists()) {
      final hours = int.tryParse(duration.hours.text);
      final minutes = int.tryParse(duration.minutes.text);
      final seconds = int.tryParse(duration.seconds.text);

      if (hours != null && minutes != null && seconds != null) {
        enableLoop.value = true;
      }
    } else {
      enableLoop.value = false;
    }
  }

  /// Loop video
  Future<void> renderLoopedVideo() async {
    final value = Duration(
      hours: int.parse(duration.hours.text),
      minutes: int.parse(duration.minutes.text),
      seconds: int.parse(duration.seconds.text),
    );

    final file = Media(File(input.text));

    ffmpegOutput.value = await file.loopAndSave(File(output.text), value);
  }
}

class LoopMediaPage extends HookWidget {
  /// The loop media page can be used by the user to loop out their
  /// media files by specifying the output video duration.
  const LoopMediaPage({super.key});

  @override
  Widget build(final BuildContext context) {
    final state = _PageState();

    return FadeInRight(
      duration: const Duration(milliseconds: 200),
      child: Form(
        onChanged: state.onChangeInForm,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeadingText('Input media file.'),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: state.input,
                          enabled: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        onPressed: state.onBrowseInputFile,
                        icon: const Icon(Icons.file_copy_outlined),
                        label: 'Browse',
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const HeadingText('Loop video for'),
                  const SizedBox(height: 20),
                  DurationField(controller: state.duration),
                  const SizedBox(height: 20),
                  const HeadingText('Output media file.'),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: state.output,
                          enabled: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        icon: const Icon(Icons.save),
                        label: 'Save Location',
                        onPressed: state.onBrowseOutputFile,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    label: 'Loop',
                    icon: const Icon(Icons.loop),
                    onPressed:
                        state.enableLoop.value ? state.renderLoopedVideo : null,
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder(
                    stream: state.ffmpegOutput.value,
                    builder: (final context, final snapshot) {
                      print(snapshot.data);
                      if (snapshot.hasData && snapshot.data != null) {
                        return Text(String.fromCharCodes(snapshot.data!));
                      } else if (snapshot.data == null) {
                        return const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.terminal),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
