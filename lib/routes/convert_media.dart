import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osumffmpeg/modules/common.dart';
import 'package:osumffmpeg/modules/converter.dart';

import '../components/dropdown.dart';
import '../models/formats.dart';
import '../models/layout/convert_media/media_state.dart';
import '../models/layout/convert_media/ui_state.dart';

class ConvertMediaPage extends ConsumerWidget {
  const ConvertMediaPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final controllers = ref.watch(ConvertMediaControllersProvider.provider);
    final state = ref.watch(ConvertMediaProvider.provider);
    final notifier = ref.watch(ConvertMediaProvider.provider.notifier);

    final ffmpeg = ref.watch(FFmpegStatusStreamProvider.provider);
    final ffmpegNotifier =
        ref.watch(FFmpegStatusStreamProvider.provider.notifier);

    final validatedStatus = notifier.validate();

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
                      controller: controllers.input,
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
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles();

                      if (result != null) {
                        final file = File(result.files.single.path!);
                        controllers.input.text = file.absolute.path;
                        notifier
                          ..updateInputFile(file)
                          ..autoUpdateOutputDirectory(
                            controllers.output,
                          );
                      }
                    },
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
              CustomDropdownSearch(
                items: MediaFormats.values.map((final e) => e.value).toList(),
                onChanged: (final value) {
                  if (value != null) {
                    notifier.updateExtension(
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
                },
                value: state.extension.value,
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
                      controller: controllers.output,
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
                    onPressed: () async {
                      final location =
                          await FilePicker.platform.getDirectoryPath();
                      if (location != null) {
                        notifier.updateOutputDirectory(Directory(location));
                        controllers.output.text = location;
                      }
                    },
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
                onPressed: notifier.validate() == 'Success'
                    ? () async => ffmpegNotifier.sendToFFmpeg([
                          '-i',
                          state.inputToString(),
                          state.outputToString(),
                          '-y'
                        ])
                    : null,
                icon: const Icon(Icons.send),
                label: const Text('Convert'),
              ),
              const SizedBox(height: 10),
              if (validatedStatus != 'Success') Text(notifier.validate()),
              if (ffmpeg != null) ffmpeg,
            ],
          ),
        ),
      ),
    );
  }
}
