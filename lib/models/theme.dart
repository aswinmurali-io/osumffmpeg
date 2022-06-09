import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeProvider extends StateNotifier<ThemeMode> {
  ThemeProvider() : super(ThemeMode.system);

  static final provider = StateNotifierProvider<ThemeProvider, ThemeMode>(
    (final ref) => ThemeProvider(),
  );

  static const primarySwatch = Colors.teal;

  static const primaryGrey = Color(0xffd5d5d5);

  static const headline2 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 27,
  );

  static InputDecorationTheme getTextInputTheme(final bool isDark) {
    return InputDecorationTheme(
      iconColor: isDark ? Colors.white : Colors.black54,
      labelStyle: TextStyle(
        color: isDark ? Colors.white : Colors.black,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: primaryGrey, width: 1),
      ),
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: primaryGrey),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: primarySwatch,
      inputDecorationTheme: getTextInputTheme(false),
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: TextTheme(
        headline2: headline2.copyWith(color: Colors.black),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: primarySwatch,
      scaffoldBackgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.white),
      inputDecorationTheme: getTextInputTheme(true),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: Color.fromARGB(255, 82, 82, 82),
        unselectedIconTheme: IconThemeData(color: Colors.white),
        unselectedLabelTextStyle: TextStyle(color: Colors.white),
        selectedLabelTextStyle: TextStyle(color: Colors.tealAccent),
        selectedIconTheme: IconThemeData(color: Colors.tealAccent),
      ),
      textTheme: TextTheme(
        headline2: headline2.copyWith(color: Colors.white),
        subtitle1: const TextStyle(color: Colors.white), // TextField text!
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
