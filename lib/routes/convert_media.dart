import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path/path.dart';

import '../components/custom_button.dart';
import '../components/dropdown.dart';
import '../components/head_text.dart';
import '../engine/exec.dart';
import '../engine/media.dart';

class _PageState {
  _PageState()
      : input = useTextEditingController(),
        output = useTextEditingController(),
        enableConvert = useState(false),
        format = useState(MediaFormats.mkv),
        ffmpegOutput = useState(null);

  final TextEditingController input;

  final TextEditingController output;

  final ValueNotifier<bool> enableConvert;

  final ValueNotifier<MediaFormats> format;

  final ValueNotifier<Stream<List<int>>?> ffmpegOutput;

  Future<void> onBrowseInputFile() async {
    final path = await FilePicker.platform.saveFile();

    if (path != null) {
      input.text = path;

      output.text = join(dirname(path), autoFillOutputLocation());
    }
  }

  Future<void> onChangeInForm() async {
    if (await File(input.text).exists() &&
        await Directory(dirname(output.text)).exists()) {
      enableConvert.value = true;
    } else {
      enableConvert.value = false;
    }
  }

  String autoFillOutputLocation() =>
      '${basenameWithoutExtension(input.text)} (Converted).${format.value.value}';

  Future<void> onBrowseOutputLocation() async {
    final location = await FilePicker.platform.getDirectoryPath();

    if (location != null) {
      output.text = join(location, autoFillOutputLocation());
    }
  }

  void onFormatChange(final String? value) {
    if (value != null) {
      format.value = MediaFormats.values.firstWhere(
        (final format) => format.toString() == value,
        orElse: () {
          if (kDebugMode) {
            print(
              'Unable to find media format from enum. '
              'Falling back to m4v.',
            );
          }
          return MediaFormats.mk4;
        },
      );

      output.text = join(dirname(output.text), autoFillOutputLocation());
    }
  }

  Future<void> onConvert() async =>
      ffmpegOutput.value = await MediaEngine.executeFFmpegStream(
        executable: FFmpegExec.ffmpeg,
        commands: ['-i', input.text, output.text, '-y'],
      );
}

class ConvertMediaPage extends HookWidget {
  const ConvertMediaPage({super.key});

  @override
  Widget build(final BuildContext context) {
    final state = _PageState();

    return FadeInRight(
      duration: const Duration(milliseconds: 200),
      child: Form(
        onChanged: state.onChangeInForm,
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
                          onPressed: state.onBrowseInputFile,
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const HeadingText('Convert format to'),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 160,
                      child: CustomDropdown(
                        labelText: 'Media Format',
                        items: MediaFormats.values
                            .map((final e) => e.value)
                            .toList(),
                        onChanged: state.onFormatChange,
                        value: state.format.value.value,
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
                          onPressed: state.onBrowseOutputLocation,
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      label: 'Convert',
                      icon: const Icon(Icons.send),
                      onPressed:
                          state.enableConvert.value ? state.onConvert : null,
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<List<int>>(
                      stream: state.ffmpegOutput.value,
                      builder: (final context, final snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Text(String.fromCharCodes(snapshot.data!));
                        } else if (snapshot.data == null) {
                          return const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.terminal),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
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
