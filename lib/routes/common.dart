// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

/// Common page UI state logic containing state handlers
/// for input, output media files, FFMPEG console output,
/// action button state, etc.
abstract class CommonPageState {
  /// The [input] media file text field controller.
  TextEditingController get input;

  /// The [output] media file text field controller.
  TextEditingController get output;

  /// Show the action button.
  ValueNotifier<bool> get showAction;

  /// The FFMPEG stream output of the running action.
  ValueNotifier<Stream<List<int>>?> get ffmpegOutput;

  /// Events when the form values change.
  Future<void> onFormChanged();

  /// Run the action in FFMPEG.
  Future<void> runAction();

  /// Get the default output file location based on the [input] given.
  String getDefaultOutputLocation();

  Future<void> onInputChanged() async {
    final file = await FilePicker.platform.saveFile(
      dialogTitle: 'Input Media',
    );

    if (file != null) {
      input.text = file;

      // Don't use auto default output location if user has already specified
      // output location path.
      if (output.text == '') {
        output.text = getDefaultOutputLocation();
      }
    }
  }

  Future<void> onOutputChanged() async {
    late String? file;

    const dialogTitle = 'Output Media';

    if (await File(output.text).exists()) {
      file = await FilePicker.platform.saveFile(
        dialogTitle: dialogTitle,
        initialDirectory: dirname(output.text),
      );
    } else {
      file = await FilePicker.platform.saveFile(
        dialogTitle: dialogTitle,
      );
    }

    if (file != null) {
      output.text = file;
    }
  }
}
