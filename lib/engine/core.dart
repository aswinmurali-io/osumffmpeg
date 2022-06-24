// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'dart:convert' show utf8;
import 'dart:io';

import 'package:async/async.dart';
import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/ffprobe_kit.dart';
import 'package:flutter/services.dart';
import 'package:osumlog/osumlog.dart';

import 'errors.dart';
import 'execs.dart';
import 'utils.dart';

class _Engine {
  /// Check if no ffmpeg [exec] is present in this system.
  Future<bool> noFFmpeg(OsumExecs exec) async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        await FFmpegKit.cancel();
      } on MissingPluginException {
        return true;
      }
      return false;
    } else {
      final process = await Process.run(
        Platform.isWindows ? 'where' : 'which',
        [exec.value],
      );

      return process.exitCode != 0;
    }
  }

  Future<String> checkForExecs() async {
    for (final exec in OsumExecs.values) {
      if (await noFFmpeg(exec)) {
        return 'Unable to find ${exec.value} executable which is part of the '
            'ffmpeg project. Please download it from https://ffmpeg.org/';
      }
    }
    return 'Success';
  }

  /// Execute [commands] inside ffmpeg's [executable] and get the output
  /// as a [Stream].
  Future<Stream<List<int>>> executeFFmpegStream({
    required OsumExecs executable,
    required List<String> commands,
  }) async {
    Log.info(
      'Execute ${executable.value} ${protectUserPath(commands).join(' ')}',
    );

    if (Platform.isAndroid || Platform.isIOS) {
      switch (executable) {
        case OsumExecs.ffmpeg:
          final session = await FFmpegKit.execute(commands.join(' '));
          return session
              .getOutput()
              .asStream()
              .map((event) => utf8.encode(event!))
              .asBroadcastStream();

        case OsumExecs.ffprobe:
          final session = await FFprobeKit.execute(commands.join(' '));
          return session
              .getOutput()
              .asStream()
              .map((event) => utf8.encode(event!))
              .asBroadcastStream();
        case OsumExecs.ffplay:
          throw MissingPluginException('FFplay not available.');
      }
    } else {
      final process = await Process.start(
        executable.value,
        commands,
        runInShell: true,
        includeParentEnvironment: true,
      );

      return StreamGroup.merge([
        process.stderr,
        process.stdout,
      ]).asBroadcastStream();
    }
  }

  /// Execute [commands] inside ffmpeg's [executable] and get the output
  /// as a [String].
  Future<String> executeFFmpeg({
    required OsumExecs executable,
    required List<String> commands,
  }) async {
    Log.info(
      'Execute ${executable.value} ${protectUserPath(commands).join(' ')}',
    );

    if (Platform.isAndroid || Platform.isIOS) {
      switch (executable) {
        case OsumExecs.ffmpeg:
          final session = await FFmpegKit.execute(commands.join(' '));
          return (await session.getOutput())!;
        case OsumExecs.ffprobe:
          final session = await FFprobeKit.execute(commands.join(' '));
          return (await session.getOutput())!;
        case OsumExecs.ffplay:
          throw MissingPluginException('FFplay not available.');
      }
    } else {
      final process = await Process.run(executable.value, commands);

      Log.info('Output ${process.stdout}');

      if (process.exitCode == 1) {
        throw OsumEngineException(process.stderr);
      }
      return '${process.stdout}';
    }
  }
}

/// The osumffmpeg engine that contains low-level
/// ffmpeg command execution functions.
final osumEngine = _Engine();
