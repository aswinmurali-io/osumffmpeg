import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osumffmpeg/components/dropdown.dart';
import 'package:osumffmpeg/models/format.dart';

import '../modules/converter.dart';

class ConvertMediaPage extends ConsumerWidget {
  const ConvertMediaPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final mediaFormat = ref.watch(MediaFormatProvider.provider);
    final setMediaFormat = ref.watch(MediaFormatProvider.provider.notifier);

    return Scrollbar(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Input media file.',
                style: Theme.of(context).textTheme.headline2,
              ),
              const TextField(),
              const SizedBox(height: 20),
              Text(
                'Convert format to',
                style: Theme.of(context).textTheme.headline2,
              ),
              const SizedBox(height: 20),
              const CustomDropdownSearch(),
              const SizedBox(height: 20),
              Text(
                'Output media file.',
                style: Theme.of(context).textTheme.headline2,
              ),
              const TextField(),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(16),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.send),
                label: const Text('Convert'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
