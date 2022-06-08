import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:osumffmpeg/components/durationfield.dart';

TimeOfDay getTimeOfDayFromString(final String timeString) {
  final timeString = TimeOfDay.now().toString();
  final parts = timeString.split(':');
  final hours = int.parse(parts.first.split('(').last);
  final minutes = int.parse(parts.skip(1).first.split(')').first);
  return TimeOfDay(hour: hours, minute: minutes);
}

// String getStringFromTimeOfDay(final TimeOfDay time) {
//   return time.hour +
// }

class LoopVideoPage extends HookWidget {
  const LoopVideoPage({super.key});

  Future<void> onBrowseInputFile(
    final TextEditingController input,
  ) async {
    final file = await FilePicker.platform.saveFile();

    if (file != null) {
      input.text = file;
    }
  }

  void onBrowseOutputLocation() {}

  Future<void> onChangeLoopDuration(
    final BuildContext context,
    final TextEditingController durationHour,
    final TextEditingController durationMinutes,
  ) async {
    // final value = await showTimePicker(
    //   context: context,
    //   initialTime: TimeOfDay.now(),
    //   initialEntryMode: TimePickerEntryMode.input,
    //   onEntryModeChanged: null,
    //   builder: (final context, final child) => MediaQuery(
    //     data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
    //     child: child!,
    //   ),
    // );
    // if (value != null) {
    //   durationHour.text = '${value.hour}';
    //   durationMinutes.text = '${value.minute}';
    // }
  }

  @override
  Widget build(final BuildContext context) {
    final input = useTextEditingController();
    final output = useTextEditingController();
    final durationHours = useTextEditingController();
    final durationMinutes = useTextEditingController();

    final ffmpegOutput = useState<StreamBuilder<List<int>>?>(null);

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
                      controller: input,
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
                    onPressed: () => onBrowseInputFile(input),
                    icon: const Icon(Icons.file_copy_outlined),
                    label: const Text('Browse'),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Loop video for',
                style: Theme.of(context).textTheme.headline2,
              ),
              const SizedBox(height: 20),
              DurationField(
                hours: durationHours,
                minutes: durationMinutes,
                onTap: () => onChangeLoopDuration(
                  context,
                  durationHours,
                  durationMinutes,
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
                      controller: output,
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
                    onPressed: () {},
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
              ),
              const SizedBox(height: 10),
              // if (validatedStatus != 'Success') Text(formNotifier.validate()),
              // if (ffmpegOutput != null) ffmpegOutput,
            ],
          ),
        ),
      ),
    );
  }
}

// class LoopVideoPage extends ConsumerStatefulWidget {
//   const LoopVideoPage({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _LoopVideoPageState();
// }

// class _LoopVideoPageState extends ConsumerState<LoopVideoPage> {
//   late TextEditingController inputFileController;
//   late TextEditingController loopDurationController;
//   late TextEditingController outputFileController;

//   @override
//   void initState() {
//     inputFileController = TextEditingController();
//     outputFileController = TextEditingController();
//     loopDurationController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     inputFileController.dispose();
//     outputFileController.dispose();
//     loopDurationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(final BuildContext context) {
//     return
//   }
// }

// class LoopVideoPage extends ConsumerWidget {
//   const LoopVideoPage({super.key});

//   void onConvert(
//     final FFmpegProvider ffmpegNotifier,
//     final ConvertMediaState formState,
//   ) {
//     ffmpegNotifier.sendToFFmpeg(
//       ['-i', formState.inputToString(), formState.outputToString(), '-y'],
//     );
//   }

//   Future<void> onBrowse(
//     final ConvertMediaFormState formControllers,
//     final ConvertMediaProvider formNotifier,
//   ) async {
//     final result = await FilePicker.platform.pickFiles();

//     if (result != null) {
//       final file = File(result.files.single.path!);
//       formControllers.input.text = file.absolute.path;
//       formNotifier
//         ..updateInputFile(file)
//         ..autoUpdateOutputDirectory(
//           formControllers.output,
//         );
//     }
//   }

//   void onFormatChanged(
//     final String? value,
//     final ConvertMediaProvider formNotifier,
//   ) {
//     if (value != null) {
//       formNotifier.updateExtension(
//         MediaFormats.values.firstWhere(
//           (final format) => format.toString() == value,
//           orElse: () {
//             if (kDebugMode) {
//               print(
//                 'Unable to find media format from enum. '
//                 'Falling back to m4v.',
//               );
//             }
//             return MediaFormats.mk4;
//           },
//         ),
//       );
//     }
//   }

//   Future<void> onSaveLocation(
//     final ConvertMediaFormState formControllers,
//     final ConvertMediaProvider formNotifier,
//   ) async {
//     final location = await FilePicker.platform.getDirectoryPath();
//     if (location != null) {
//       formNotifier.updateOutputDirectory(Directory(location));
//       formControllers.output.text = location;
//     }
//   }

//   @override
//   Widget build(final BuildContext context, final WidgetRef ref) {
//     // FORM CONTROLLERS
//     final formControllers = ref.watch(ConvertMediaControllersProvider.provider);

//     // LOGIC PARAMETERS
//     final formState = ref.watch(ConvertMediaProvider.provider);
//     final formNotifier = ref.watch(ConvertMediaProvider.provider.notifier);

//     // FFMPEG
//     final ffmpegStatus = ref.watch(FFmpegProvider.provider);
//     final ffmpegNotifier = ref.watch(FFmpegProvider.provider.notifier);

//     final validatedStatus = formNotifier.validate();

//     return Container();
//   }
// }
