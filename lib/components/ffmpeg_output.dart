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
