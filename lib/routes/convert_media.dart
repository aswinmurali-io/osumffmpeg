import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/dropdown.dart';
import '../engine/media.dart';
import '../models/layout/convert_media/media_state.dart';
import '../models/layout/convert_media/ui_state.dart';
import '../modules/common.dart';

class ConvertMediaPage extends ConsumerWidget {
  const ConvertMediaPage({super.key});

  void onConvert(
    final FFmpegProvider ffmpegNotifier,
    final ConvertMediaState formState,
  ) {
    ffmpegNotifier.sendToFFmpeg(
      ['-i', formState.inputToString(), formState.outputToString(), '-y'],
    );
  }

  Future<void> onBrowse(
    final ConvertMediaFormState formControllers,
    final ConvertMediaProvider formNotifier,
  ) async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final file = File(result.files.single.path!);
      formControllers.input.text = file.absolute.path;
      formNotifier
        ..updateInputFile(file)
        ..autoUpdateOutputDirectory(
          formControllers.output,
        );
    }
  }

  void onFormatChanged(
    final String? value,
    final ConvertMediaProvider formNotifier,
  ) {
    if (value != null) {
      formNotifier.updateExtension(
        MediaFormats.values.firstWhere(
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
        ),
      );
    }
  }

  Future<void> onSaveLocation(
    final ConvertMediaFormState formControllers,
    final ConvertMediaProvider formNotifier,
  ) async {
    final location = await FilePicker.platform.getDirectoryPath();
    if (location != null) {
      formNotifier.updateOutputDirectory(Directory(location));
      formControllers.output.text = location;
    }
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // FORM CONTROLLERS
    final formControllers = ref.watch(ConvertMediaControllersProvider.provider);

    // LOGIC PARAMETERS
    final formState = ref.watch(ConvertMediaProvider.provider);
    final formNotifier = ref.watch(ConvertMediaProvider.provider.notifier);

    // FFMPEG
    final ffmpegStatus = ref.watch(FFmpegProvider.provider);
    final ffmpegNotifier = ref.watch(FFmpegProvider.provider.notifier);

    final validatedStatus = formNotifier.validate();

    return Scrollbar(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Input media file.',
                style: Theme.of(context).textTheme.headline2,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: formControllers.input,
                      enabled: false,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(16),
                      ),
                    ),
                    onPressed: () => onBrowse(formControllers, formNotifier),
                    icon: const Icon(Icons.file_copy_outlined),
                    label: const Text('Browse'),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Convert format to',
                style: Theme.of(context).textTheme.headline2,
              ),
              const SizedBox(height: 20),
              // ---------------------------------------------------------------
              // Media Format Dropdown
              // ---------------------------------------------------------------
              SizedBox(
                width: 160,
                child: OsumDropdown(
                  labelText: 'Media Format',
                  items: MediaFormats.values.map((final e) => e.value).toList(),
                  onChanged: (final value) =>
                      onFormatChanged(value, formNotifier),
                  value: formState.extension.value,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Output media file.',
                style: Theme.of(context).textTheme.headline2,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: formControllers.output,
                      enabled: false,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(16),
                      ),
                    ),
                    onPressed: () =>
                        onSaveLocation(formControllers, formNotifier),
                    icon: const Icon(Icons.save),
                    label: const Text('Save Location'),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(16),
                  ),
                ),
                onPressed: formNotifier.validate() == 'Success'
                    ? () => onConvert(ffmpegNotifier, formState)
                    : null,
                icon: const Icon(Icons.send),
                label: const Text('Convert'),
              ),
              const SizedBox(height: 10),
              if (validatedStatus != 'Success') Text(formNotifier.validate()),
              if (ffmpegStatus != null) ffmpegStatus,
            ],
          ),
        ),
      ),
    );
  }
}
