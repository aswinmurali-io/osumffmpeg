// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class FfmpegOutput extends StatelessWidget {
  const FfmpegOutput({super.key, required this.outputStream});

  final Stream<List<int>>? outputStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: outputStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Text(String.fromCharCodes(snapshot.data!));
        } else if (snapshot.data == null) {
          return const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.terminal),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
