import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class _FormState {
  const _FormState({
    required this.input,
    required this.output,
  });

  final TextEditingController input;

  final TextEditingController output;
}

class ConvertMediaControllersProvider extends StateNotifier<_FormState> {
  ConvertMediaControllersProvider()
      : super(
          _FormState(
            input: TextEditingController(),
            output: TextEditingController(),
          ),
        );

  static final provider =
      StateNotifierProvider<ConvertMediaControllersProvider, _FormState>(
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
