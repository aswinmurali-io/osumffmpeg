// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path/path.dart';

import '../components/custom_button.dart';
import '../components/duration_field.dart';
import '../components/ffmpeg_output.dart';
import '../components/head_text.dart';
import '../engine/media.dart';
import 'common.dart';

class _PageState extends CommonPageState {
  /// The loop media page state.
  _PageState()
      : input = useTextEditingController(),
        output = useTextEditingController(),
        duration = DurationController(),
        showAction = useState(false),
        ffmpegOutput = useState(null);

  @override
  final TextEditingController input;

  @override
  final TextEditingController output;

  /// The [duration] of the looped media file.
  final DurationController duration;

  @override
  final ValueNotifier<bool> showAction;

  @override
  final ValueNotifier<Stream<List<int>>?> ffmpegOutput;

  Future<void> onInputChangedWithExtraLogic() async =>
      onInputChanged().then((_) => autoFillDuration());

  Future<void> autoFillDuration() async {
    final inputFile = File(input.text);

    if (await inputFile.exists()) {
      final totalDuration = await Media(File(input.text)).getDuration();

      duration.hours.text = '${totalDuration.inHours.remainder(24)}';
      duration.minutes.text = '${totalDuration.inMinutes.remainder(60)}';
      duration.seconds.text = '${totalDuration.inSeconds.remainder(60)}';
    }
  }

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
      final hours = int.tryParse(duration.hours.text);
      final minutes = int.tryParse(duration.minutes.text);
      final seconds = int.tryParse(duration.seconds.text);

      if (hours != null &&
          minutes != null &&
          seconds != null &&
          // Duration must be greater than 1 second atleast.
          hours + minutes + seconds > 0) {
        showAction.value = true;
        return;
      }
    }
    showAction.value = false;
  }

  @override
  Future<void> runAction() async {
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
                        onPressed: state.onInputChangedWithExtraLogic,
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
                        onPressed: state.onOutputChanged,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    label: 'Loop',
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
