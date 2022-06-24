// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path/path.dart';

import '../components/custom_button.dart';
import '../components/ffmpeg_output.dart';
import '../components/head_text.dart';
import '../components/video_duration_slider.dart';
import '../engine/media.dart';
import 'common.dart';

class _PageState extends CommonPageState {
  _PageState()
      : input = useTextEditingController(),
        output = useTextEditingController(),
        showAction = useState(false),
        ffmpegOutput = useState(null),
        video = VideoDurationSliderController();

  @override
  final TextEditingController input;

  @override
  final TextEditingController output;

  @override
  final ValueNotifier<bool> showAction;

  @override
  final ValueNotifier<Stream<List<int>>?> ffmpegOutput;

  final VideoDurationSliderController video;

  Future<void> onInputChangedWithExtraLogic() async {
    await onInputChanged();

    video
      ..resetPosition()
      ..changeFile(File(input.text));

    await video.fetchTotalTime();
  }

  @override
  Future<void> onFormChanged() async {
    if (await File(input.text).exists() &&
        await Directory(dirname(output.text)).exists()) {
      showAction.value = true;
    } else {
      showAction.value = false;
    }
  }

  @override
  String getDefaultOutputLocation() => join(
        dirname(input.text),
        '${basenameWithoutExtension(input.text)} Frames/',
      );

  Future<void> fixOutputLocation() async {
    final outputDir = Directory(output.text);
    if (!await outputDir.exists()) {
      await outputDir.create();
    }
  }

  @override
  Future<void> onOutputChanged() async {
    final directory = await FilePicker.platform.getDirectoryPath();

    if (directory != null) {
      output.text = directory;
    }
  }

  @override
  Future<void> runAction() async {
    await fixOutputLocation();
    await OsumMedia(File(input.text)).saveFrame(
      Duration(seconds: video.position.value),
      File(
        '${output.text}/${basenameWithoutExtension(input.text)} (${video.position.value}th sec).jpg',
      ),
    );

    ffmpegOutput.value = Stream.value(utf8.encode('No output.'));
  }

  Future<void> runActionSaveAllFrames() async {
    await fixOutputLocation();
    ffmpegOutput.value = await OsumMedia(File(input.text))
        .saveAllFrames(Directory(output.text), 'bmp');
  }
}

class SavePhotoFromVideoPage extends HookWidget {
  const SavePhotoFromVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = _PageState();

    return FadeInRight(
      duration: const Duration(milliseconds: 200),
      child: Form(
        onChanged: state.onFormChanged,
        child: FadeInRight(
          duration: const Duration(milliseconds: 200),
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
                          label: 'Browse',
                          icon: const Icon(Icons.file_copy_outlined),
                          onPressed: state.onInputChangedWithExtraLogic,
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const HeadingText('Pause where you want to take a photo.'),
                    const SizedBox(height: 20),
                    VideoDurationSlider(
                      controller: state.video,
                    ),
                    const SizedBox(height: 20),
                    const HeadingText('Output thumbnail location.'),
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
                          label: 'Save Location',
                          icon: const Icon(Icons.save),
                          onPressed: state.onOutputChanged,
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      children: [
                        CustomButton(
                          label: 'Save Photo',
                          icon: const Icon(Icons.save),
                          onPressed:
                              state.showAction.value ? state.runAction : null,
                        ),
                        const SizedBox(width: 20),
                        CustomButton(
                          label: 'Extract everything',
                          icon: const Icon(Icons.save_alt),
                          onPressed: state.showAction.value
                              ? state.runActionSaveAllFrames
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FfmpegOutput(outputStream: state.ffmpegOutput.value),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
