import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:osumffmpeg/engine/utils.dart';
import 'package:path/path.dart';

import '../components/custom_button.dart';
import '../components/custom_searchable_textfield.dart';
import '../components/ffmpeg_output.dart';
import '../components/head_text.dart';
import '../engine/enums/resolution.dart';
import '../engine/media.dart';

class _PageState {
  /// The loop media page state.
  _PageState()
      : input = useTextEditingController(),
        output = useTextEditingController(),
        resolution = useTextEditingController(),
        enableScale = useState(false),
        ffmpegOutput = useState(null);

  /// The [input] media file text field controller.
  final TextEditingController input;

  /// The [output] looped media file text field controller.
  final TextEditingController output;

  /// The [resolution] of the looped media file.
  final TextEditingController resolution;

  /// Should the loop button be enabled.
  final ValueNotifier<bool> enableScale;

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

    return '$path/$filename (Scaled)$ext';
  }

  /// On browsing the input file to loop.
  Future<void> onBrowseInputFile() async {
    final file = await FilePicker.platform.saveFile(
      dialogTitle: 'Pick input media file.',
    );

    if (file != null) {
      input.text = file;

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

  /// Checking if the form is valid to enable scale button.
  Future<void> onChangeInForm() async {
    if (await File(input.text).exists() &&
        await Directory(dirname(output.text)).exists()) {
      try {
        MediaResolution.fromString(resolution.text);
        enableScale.value = true;
      } on InvalidMediaResolution {
        enableScale.value = false;
      }
    }
  }

  void onChangeInScale(String? value) {}

  /// Scale video
  Future<void> renderScaleVideo() async {
    final file = Media(File(input.text));

    final value = MediaResolution.fromString(resolution.text);

    ffmpegOutput.value = await file.scale(value, File(output.text));
  }
}

class ScaleVideoPage extends HookWidget {
  /// The scale video page can be used by the user to upscale or downscale
  /// video resolution.
  const ScaleVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const HeadingText('Output Resolution'),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 230,
                    child: CustomSearchableTextField<MediaResolutions>(
                      controller: state.resolution,
                      options: MediaResolutions.values,
                      hintText: 'Type or search for media resolutions.',
                      onChanged: state.onChangeInScale,
                    ),
                  ),
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
                        state.enableScale.value ? state.renderScaleVideo : null,
                  ),
                  const SizedBox(height: 10),
                  FfmpegOutput(outputStream: state.ffmpegOutput.value)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
