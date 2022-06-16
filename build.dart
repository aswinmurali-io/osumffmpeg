// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

/// Osumffmpeg's project helper script.
///
/// Usage:
///   dart build.dart [command]
///
/// Sync github pages
///   dart build.dart sync_githubpage
///
/// Build & pack win32 app
///   dart build.dart build_win32
///
// ignore_for_file: avoid_print

import 'dart:io';

import 'package:path/path.dart';

const syncRawForGitHubPages = false;
const buildInstallerInWindows = true;
const reduceExecutableSizeInWindows = true;

void main(List<String> args) async {
  switch (args.first) {
    case 'sync_githubpage':
      return syncGitHubPages();
    case 'build_win32':
      return buildWin32();
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
void buildWin32() {
  run(
    'Running flutter pub get',
    'flutter',
    ['pub', 'get'],
    then: () => run(
      'Building windows desktop application',
      'flutter',
      ['build', 'windows'],
      then: () => run(
        'Compressing *.dll (flutter_windows.dll, etc)',
        'upx',
        ['build/windows/runner/Release/*.dll'],
        flag: reduceExecutableSizeInWindows,
        then: () => run(
          'Building windows installer',
          'iscc',
          ['win32_installer.iss'],
          flag: buildInstallerInWindows,
          then: () => print('Done'),
        ),
      ),
    ),
  );
}
