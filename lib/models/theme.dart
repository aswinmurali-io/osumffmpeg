import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeState extends StateNotifier<ThemeMode> {
  ThemeState() : super(ThemeMode.system);

  static final provider =
      StateNotifierProvider<ThemeState, ThemeMode>((final ref) => ThemeState());

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.cyan,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      scaffoldBackgroundColor: Colors.transparent,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.transparent,
    );
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.dark;
    }
  }
}
