import 'dart:io';

import 'package:osumffmpeg/modules/common.dart';

import '../models/layout/convert_media/media_state.dart';

class Converter {
  static Future<void> run(
    final dynamic provider,
    final ConvertMediaState form,
  ) async =>
      provider.sendToFFmpeg(
        ['-i', form.inputToString(), form.outputToString(), '-y'],
      );
}
