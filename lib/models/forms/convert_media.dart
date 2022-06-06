import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

import '../formats.dart';

@immutable
class ConvertMediaForm {
  const ConvertMediaForm({
    this.inputFile,
    this.outputDirectory,
    this.outputExtension,
  });

  final File? inputFile;

  final Directory? outputDirectory;

  final MediaFormats? outputExtension;
}

@immutable
class ConvertMediaFormControllers {
  const ConvertMediaFormControllers({
    required this.inputFileController,
    required this.outputFileController,
  });

  final TextEditingController inputFileController;

  final TextEditingController outputFileController;
}

class ConvertMediaControllersProvider
    extends StateNotifier<ConvertMediaFormControllers> {
  ConvertMediaControllersProvider()
      : super(
          ConvertMediaFormControllers(
            inputFileController: TextEditingController(),
            outputFileController: TextEditingController(),
          ),
        );

  static final provider = StateNotifierProvider<ConvertMediaControllersProvider,
      ConvertMediaFormControllers>(
    (final ref) => ConvertMediaControllersProvider(),
  );

  @override
  void dispose() {
    state.inputFileController.dispose();
    state.outputFileController.dispose();
    super.dispose();
  }
}

class ConvertMediaProvider extends StateNotifier<ConvertMediaForm> {
  ConvertMediaProvider() : super(const ConvertMediaForm());

  static final provider =
      StateNotifierProvider<ConvertMediaProvider, ConvertMediaForm>(
    (final ref) => ConvertMediaProvider(),
  );

  void onChoosingExtension(final MediaFormats format) =>
      state = ConvertMediaForm(
        inputFile: state.inputFile,
        outputDirectory: state.outputDirectory,
        outputExtension: format,
      );

  void onChoosingInput(final File input) => state = ConvertMediaForm(
        inputFile: input,
        outputDirectory: state.outputDirectory,
        outputExtension: state.outputExtension,
      );

  void setOutputDirectory(final Directory location) => state = ConvertMediaForm(
        inputFile: state.inputFile,
        outputDirectory: location,
        outputExtension: state.outputExtension,
      );

  void autoSetOutputDirectory(final TextEditingController controller) {
    if (state.inputFile != null) {
      final rawPath = dirname(state.inputFile!.path);

      controller.text = rawPath;

      setOutputDirectory(Directory(rawPath));
    } else {
      if (kDebugMode) {
        print('Called auto set output directory before getting input file');
      }
    }
  }

  Future<String> validate() async {
    if (state.inputFile == null) {
      return 'Input file is not given.';
    } else if (state.inputFile != null && await state.inputFile!.exists()) {
      return 'Input media file does not seem to be a valid file or does not exist.';
    } else if (state.outputDirectory == null) {
      return 'The output location is not set.';
    } else if (state.outputDirectory != null &&
        await state.outputDirectory!.exists()) {
      return 'The output location is not a valid location.';
    } else if (state.outputExtension == null) {
      return 'The output extension is not set';
    }
    return 'Success';
  }
}
