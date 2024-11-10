// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path/path.dart';

import '../components/custom_button.dart';
import '../components/custom_searchable_textfield.dart';
import '../components/ffmpeg_output.dart';
import '../components/head_text.dart';
import '../engine/formats.dart';
import '../engine/media.dart';
import 'common.dart';

class _PageState extends CommonPageState {
  _PageState()
      : input = useTextEditingController(),
        output = useTextEditingController(),
        format = useTextEditingController(),
        showAction = useState(false),
        ffmpegOutput = useState(null);

  @override
  final TextEditingController input;

  @override
  final TextEditingController output;

  final TextEditingController format;

  @override
  final ValueNotifier<bool> showAction;

  @override
  final ValueNotifier<Stream<List<int>>?> ffmpegOutput;

  @override
  Future<void> onFormChanged() async {
    if (await File(input.text).exists() &&
        await Directory(dirname(output.text)).exists() &&
        format.text.isNotEmpty &&
        format.text != ' ' &&
        format.text[0] != '.') {
      showAction.value = true;
    } else {
      showAction.value = false;
    }
  }

  @override
  String getDefaultOutputLocation() {
    final path = dirname(input.text);
    final filename = basenameWithoutExtension(input.text);

    return '$path/$filename (Converted).${format.text}';
  }

  void onFormatChanged(String value) {
    if (output.text.isNotEmpty) {
      final base = basenameWithoutExtension(output.text);

      output.text = join(dirname(output.text), '$base.${format.text}');
    }
  }

  @override
  Future<void> runAction() async => ffmpegOutput.value =
      await OsumMedia(File(input.text)).saveToFormat(File(output.text));
}

class ConvertMediaPage extends HookWidget {
  const ConvertMediaPage({super.key});

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
                        label: 'Browse',
                        icon: const Icon(Icons.file_copy_outlined),
                        onPressed: state.onInputChanged,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const HeadingText('Convert format to'),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    child: CustomSearchableTextField<OsumFormats>(
                      controller: state.format,
                      options: OsumFormats.values,
                      hintText: 'Media Formats',
                      onChanged: state.onFormatChanged,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp("[0-9a-zA-Z]"),
                        ),
                      ],
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
                        label: 'Save Location',
                        icon: const Icon(Icons.save),
                        onPressed: state.onOutputChanged,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    label: 'Convert',
                    icon: const Icon(Icons.send),
                    onPressed: state.showAction.value ? state.runAction : null,
                  ),
                  const SizedBox(height: 10),
                  FfmpegOutput(outputStream: state.ffmpegOutput.value),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
