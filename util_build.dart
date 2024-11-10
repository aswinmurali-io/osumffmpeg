// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

library osum_ffmpeg_util;

/// Osumffmpeg's project helper script.
///
/// Usage:
///   dart util_build.dart [command]
///
/// Sync github pages
///   dart util_build.dart sync_githubpage
///
/// Build & pack windows app
///   dart util_build.dart windows
///
/// Build & pack linux app
///   dart util_build.dart linux
///
// ignore_for_file: avoid_print

import 'dart:io';

import 'package:path/path.dart';

const syncRawForGitHubPages = false;
const buildInstallerInWindows = true;
const reduceExecutableSize = true;

void main(List<String> args) async {
  switch (args.first) {
    case 'sync_githubpage':
      return syncGitHubPages();
    case 'windows':
      return buildWindows();
    case 'linux':
      return buildLinux();
    default:
      print('Unknown command');
  }
}

/// Helps the build script run commands in a cascading fashion.
/// Do not await! Use [then] instead.
// ignore: avoid_void_async
void run(
  String msg,
  String executable,
  List<String> arguments, {
  bool flag = true,
  void Function()? then,
}) async {
  if (flag) {
    print('$msg...');
    final result = await Process.start(
      executable,
      arguments,
      runInShell: true,
    );

    result.stderr.listen(
      (event) => stdout.write('    Stderr: ${String.fromCharCodes(event)}'),
    );

    result.stdout.listen(
      (event) => stdout.write('    Stdout: ${String.fromCharCodes(event)}'),
      onDone: then,
    );
  }
}

void runUpx(String path, {void Function()? then}) {
  run(
    'Compressing native libraries (libflutter, etc)',
    'upx',
    [path],
    flag: reduceExecutableSize,
    then: then,
  );
}

void runBuild(String platform, {void Function()? then}) {
  run(
    'Building $platform application',
    'flutter',
    ['build', platform],
    then: then,
  );
}

void runPub({void Function()? then}) {
  run(
    'Running flutter pub get',
    'flutter',
    ['pub', 'get'],
    then: then,
  );
}

// x------------------------------------------------x
// |  Command logic                                 |
// x------------------------------------------------x

/// Sync osumffmpeg's github page.
void syncGitHubPages() {
  final readme = File('README.md');
  final githubPageDirectory = Directory('docs');
  final githubPagePath = join(githubPageDirectory.path, 'index.md');

  print(
    'Copying ${readme.path} to ${githubPageDirectory.path} as $githubPagePath',
  );

  readme.copySync(githubPagePath);

  if (!syncRawForGitHubPages) {
    final index = File(githubPagePath);

    // Remove </br> tags as they appear raw in github page.
    final modifiedContent = index.readAsStringSync().replaceAll('</br>', '');

    index.writeAsStringSync(modifiedContent);
  }
}

/// Build and package a desktop win32-based windows application for osumffmpeg.
void buildWindows() {
  runPub(
    then: () => runBuild(
      'windows',
      then: () => runUpx(
        'build/windows/runner/Release/*.dll',
        then: () => run(
          'Building windows installer',
          'iscc',
          ['innosetup.iss'],
          flag: buildInstallerInWindows,
          then: () => print('Done'),
        ),
      ),
    ),
  );
}

void buildLinux() {
  runPub(
    then: () => runBuild(
      'linux',
      then: () => runUpx(
        'build/linux/x64/release/bundle/lib/*.so',
        then: () => print('Done'),
      ),
    ),
  );
}
