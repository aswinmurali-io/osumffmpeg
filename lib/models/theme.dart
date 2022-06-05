import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeProvider extends StateNotifier<ThemeMode> {
  ThemeProvider() : super(ThemeMode.system);

  static final provider = StateNotifierProvider<ThemeProvider, ThemeMode>(
    (final ref) => ThemeProvider(),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.teal,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      scaffoldBackgroundColor: Colors.transparent,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: Color.fromARGB(255, 82, 82, 82),
        unselectedIconTheme: IconThemeData(
          color: Colors.white,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: Colors.white,
        ),
        selectedLabelTextStyle: TextStyle(
          color: Colors.tealAccent,
        ),
        selectedIconTheme: IconThemeData(
          color: Colors.tealAccent,
        ),
      ),
    );
  }

  void toggleTheme() {
    switch (state) {
      case ThemeMode.dark:
        state = ThemeMode.light;
        break;
      case ThemeMode.light:
        state = ThemeMode.system;
        break;
      default:
        state = ThemeMode.dark;
        break;
    }
  }
}
