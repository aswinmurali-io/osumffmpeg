import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class ConvertMediaFormState {
  const ConvertMediaFormState({
    required this.input,
    required this.output,
  });

  final TextEditingController input;

  final TextEditingController output;
}

class ConvertMediaControllersProvider extends StateNotifier<ConvertMediaFormState> {
  ConvertMediaControllersProvider()
      : super(
          ConvertMediaFormState(
            input: TextEditingController(),
            output: TextEditingController(),
          ),
        );

  static final provider =
      StateNotifierProvider<ConvertMediaControllersProvider, ConvertMediaFormState>(
    (final ref) {
      return ConvertMediaControllersProvider();
    },
  );

  @override
  void dispose() {
    state.input.dispose();
    state.output.dispose();
    super.dispose();
  }
}
