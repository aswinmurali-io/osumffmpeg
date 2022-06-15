import 'package:flutter/material.dart';
import 'package:osumffmpeg/components/head_text.dart';

class WorkInProgress extends StatelessWidget {
  const WorkInProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: const [
          SizedBox(height: 30),
          Icon(Icons.construction, size: 90),
          HeadingText("Work in progress"),
        ],
      ),
    );
  }
}
