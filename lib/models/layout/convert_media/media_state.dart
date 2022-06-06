import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

import '../../formats.dart';

@immutable
class ConvertMediaState {
  const ConvertMediaState({
    this.input,
    this.output,
    required this.extension,
  });

  final File? input;

  final Directory? output;

  final MediaFormats extension;

  String inputToString() => input!.absolute.path;

  String outputToString() =>
      '${output!.absolute.path}/${basename(input!.path)}.${extension.value}';
}

class ConvertMediaProvider extends StateNotifier<ConvertMediaState> {
  ConvertMediaProvider()
      : super(const ConvertMediaState(extension: MediaFormats.mk4));

  static final provider =
      StateNotifierProvider<ConvertMediaProvider, ConvertMediaState>(
    (final ref) => ConvertMediaProvider(),
  );

  void updateExtension(final MediaFormats format) {
    state = ConvertMediaState(
      input: state.input,
      output: state.output,
      extension: format,
    );
  }

  void updateInputFile(final File input) {
    state = ConvertMediaState(
      input: input,
      output: state.output,
      extension: state.extension,
    );
  }

  void updateOutputDirectory(final Directory location) {
    state = ConvertMediaState(
      input: state.input,
      output: location,
      extension: state.extension,
    );
  }

  void autoUpdateOutputDirectory(final TextEditingController controller) {
    if (state.input != null) {
      final rawPath = dirname(state.input!.path);

      controller.text = rawPath;

      updateOutputDirectory(Directory(rawPath));
    } else {
      if (kDebugMode) {
        print('Called auto set output directory before getting input file');
      }
    }
  }

  String validate() {
    if (state.input == null) {
      return 'Input file is not given.';
    } else if (state.input != null && !state.input!.existsSync()) {
      return 'Input media file does not seem to be a valid file or does not exist.';
    } else if (state.output == null) {
      return 'The output location is not set.';
    } else if (state.output != null && !state.output!.existsSync()) {
      return 'The output location is not a valid location.';
    }
    return 'Success';
  }
}
