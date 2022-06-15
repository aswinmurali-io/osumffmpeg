import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path/path.dart';

import '../components/custom_button.dart';
import '../components/custom_searchable_textfield.dart';
import '../components/ffmpeg_output.dart';
import '../components/head_text.dart';
import '../engine/enums/resolution.dart';
import '../engine/errors.dart';
import '../engine/media.dart';
import 'common.dart';

class _PageState extends CommonPageState {
  _PageState()
      : input = useTextEditingController(),
        output = useTextEditingController(),
        resolution = useTextEditingController(),
        showAction = useState(false),
        ffmpegOutput = useState(null);

  @override
  final TextEditingController input;

  @override
  final TextEditingController output;

  /// The [resolution] of the looped media file.
  final TextEditingController resolution;

  /// Should the scale button be enabled.
  @override
  final ValueNotifier<bool> showAction;

  @override
  final ValueNotifier<Stream<List<int>>?> ffmpegOutput;

  @override
  String getDefaultOutputLocation() {
    final path = dirname(input.text);
    final filename = basenameWithoutExtension(input.text);
    final ext = extension(input.text);

    return '$path/$filename (Looped)$ext';
  }

  @override
  Future<void> onFormChanged() async {
    if (await File(input.text).exists() &&
        await Directory(dirname(output.text)).exists()) {
      try {
        MediaResolution.fromString(resolution.text);
        showAction.value = true;
      } on InvalidMediaResolution {
        showAction.value = false;
      }
    }
  }

  @override
  Future<void> runAction() async {
    final file = Media(File(input.text));

    final value = MediaResolution.fromString(resolution.text);

    ffmpegOutput.value = await file.scaleVideo(value, File(output.text));
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
        onChanged: state.onFormChanged,
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
                        onPressed: state.onInputChanged,
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
                      onChanged: (_) {},
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
                        onPressed: state.onOutputChanged,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    label: 'Scale',
                    icon: const Icon(Icons.loop),
                    onPressed: state.showAction.value ? state.runAction : null,
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
