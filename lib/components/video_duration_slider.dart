import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../engine/media.dart';

class VideoDurationSliderController {
  VideoDurationSliderController()
      : file = useState(null),
        duration = useState(Duration.zero),
        position = useState(0),
        frame = useState(null);

  ValueNotifier<MemoryImage?> frame;

  ValueNotifier<File?> file;

  ValueNotifier<Duration> duration;

  ValueNotifier<int> position;

  // ignore: use_setters_to_change_properties
  void changeFile(File videoFile) => file.value = videoFile;

  Future<void> fetchTotalTime() async {
    if (file.value != null) {
      duration.value = await OsumMedia(file.value!).getDuration();
    }
  }

  String displayDuration(Duration duration) =>
      duration.toString().split('.').first.padLeft(8, '0');

  Future<void> fetchFrame() async {
    frame.value = await OsumMedia(file.value!).getFrame(
      Duration(seconds: position.value),
    );
  }

  void resetPosition() => position.value = 0;
}

class VideoDurationSlider extends HookWidget {
  const VideoDurationSlider({
    super.key,
    required this.controller,
  });

  final VideoDurationSliderController controller;

  @override
  Widget build(BuildContext context) {
    final position = Duration(seconds: controller.position.value);

    return Column(
      children: [
        if (controller.frame.value != null)
          Image(
            image: controller.frame.value!,
            width: 300,
            height: 200,
          )
        else
          const SizedBox(
            width: 300,
            height: 200,
            child: Column(
              children: [
                SizedBox(height: 30),
                Icon(Icons.sync, size: 50),
                SizedBox(height: 10),
                Text('Seek the video to preview frame'),
              ],
            ),
          ),
        Row(
          children: [
            Text(controller.displayDuration(position)),
            Expanded(
              child: Slider(
                value: controller.position.value.toDouble(),
                max: controller.duration.value.inSeconds.toDouble(),
                onChanged: (value) => controller.position.value = value.toInt(),
                onChangeEnd: (value) => controller.fetchFrame(),
              ),
            ),
            Text(controller.displayDuration(controller.duration.value)),
          ],
        ),
      ],
    );
  }
}
