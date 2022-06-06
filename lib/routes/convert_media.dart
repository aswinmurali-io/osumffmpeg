import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/dropdown.dart';
import '../models/forms/convert_media.dart';

class ConvertMediaPage extends ConsumerWidget {
  const ConvertMediaPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final controllers = ref.watch(ConvertMediaControllersProvider.provider);
    final state = ref.watch(ConvertMediaProvider.provider);
    final stateNotifier = ref.watch(ConvertMediaProvider.provider.notifier);

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
                      controller: controllers.inputFileController,
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
                        controllers.inputFileController.text =
                            file.absolute.path;
                        stateNotifier
                          ..onChoosingInput(file)
                          ..autoSetOutputDirectory(
                            controllers.outputFileController,
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
              const CustomDropdownSearch(),
              const SizedBox(height: 20),
              Text(
                'Output media file.',
                style: Theme.of(context).textTheme.headline2,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controllers.outputFileController,
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
                        stateNotifier.setOutputDirectory(Directory(location));
                        controllers.outputFileController.text = location;
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
                onPressed: () {},
                icon: const Icon(Icons.send),
                label: const Text('Convert'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
