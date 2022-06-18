import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'head_text.dart';

class NotifyNoFfmpeg extends StatelessWidget {
  const NotifyNoFfmpeg({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(height: 120),
              ZoomIn(
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.error, size: 90),
              ),
              const HeadingText('FFMPEG is not installed in your device.'),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'FFMPEG is an open-source software with complete, cross-platform solution to '
                  'record, convert and stream audio and video used by this app.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
