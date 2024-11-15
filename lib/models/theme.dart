// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends StateNotifier<ThemeMode> {
  ThemeProvider() : super(ThemeMode.system);

  // TODO: Find a better solution by check screen width.
  static bool get isMobile =>
      Platform.isAndroid || Platform.isFuchsia || Platform.isIOS;

  /// Converts any [color] of type [Colors] to [MaterialColor].
  static MaterialColor colorToMaterial(Color color) =>
      MaterialColor(color.toARGB32(), getSwatch(color));

  /// Get swatch from a [color].
  /// source: https://stackoverflow.com/questions/46595466/is-there-a-map-of-material-design-colors-for-flutter
  static Map<int, Color> getSwatch(Color color) {
    final hslColor = HSLColor.fromColor(color);
    final lightness = hslColor.lightness;

    /// if [500] is the default color, there are at LEAST five
    /// steps below [500]. (i.e. 400, 300, 200, 100, 50.) A
    /// divisor of 5 would mean [50] is a lightness of 1.0 or
    /// a color of #ffffff. A value of six would be near white
    /// but not quite.
    const lowDivisor = 6;

    /// if [500] is the default color, there are at LEAST four
    /// steps above [500]. A divisor of 4 would mean [900] is
    /// a lightness of 0.0 or color of #000000
    const highDivisor = 5;

    final lowStep = (1.0 - lightness) / lowDivisor;
    final highStep = lightness / highDivisor;

    return {
      50: hslColor.withLightness(lightness + (lowStep * 5)).toColor(),
      100: hslColor.withLightness(lightness + (lowStep * 4)).toColor(),
      200: hslColor.withLightness(lightness + (lowStep * 3)).toColor(),
      300: hslColor.withLightness(lightness + (lowStep * 2)).toColor(),
      400: hslColor.withLightness(lightness + lowStep).toColor(),
      500: hslColor.withLightness(lightness).toColor(),
      600: hslColor.withLightness(lightness - highStep).toColor(),
      700: hslColor.withLightness(lightness - (highStep * 2)).toColor(),
      800: hslColor.withLightness(lightness - (highStep * 3)).toColor(),
      900: hslColor.withLightness(lightness - (highStep * 4)).toColor(),
    };
  }

  static final provider = StateNotifierProvider<ThemeProvider, ThemeMode>(
    (ref) => ThemeProvider(),
  );

  static const primarySwatch = Colors.teal;

  static const primaryGrey = Color(0xffd5d5d5);

  static const headline2 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 27,
  );

  static InputDecorationTheme getTextInputTheme(bool isDark) {
    return InputDecorationTheme(
      iconColor: isDark ? Colors.white : Colors.black54,
      labelStyle: TextStyle(
        color: isDark ? Colors.white : Colors.black,
      ),
      hintStyle: TextStyle(
        color: isDark ? Colors.white : null,
      ),
      // Searchable dropdown's border theme.
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isDark ? Colors.white : Colors.black26,
          width: 1,
        ), //
      ),
      // TextField + Searchable suggestion widget focused border theme.
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isDark ? Colors.white : primarySwatch,
          width: isDark ? 2.5 : 1.3,
        ), //
      ),
      // Disabled text field used for media paths.
      disabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: isDark ? Colors.white : Colors.black54,
        ),
      ),
    );
  }

  static void refreshWindowTheme(ThemeMode themeMode) {
    if (themeMode == ThemeMode.dark) {
      Window.setEffect(effect: WindowEffect.acrylic, dark: true);
    } else if (themeMode == ThemeMode.system) {
      if (PlatformDispatcher.instance.platformBrightness == Brightness.light) {
        Window.setEffect(effect: WindowEffect.mica, dark: false);
      } else {
        Window.setEffect(effect: WindowEffect.acrylic, dark: true);
      }
    } else {
      Window.setEffect(effect: WindowEffect.mica, dark: false);
    }
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: primarySwatch,
      inputDecorationTheme: getTextInputTheme(false),
      scaffoldBackgroundColor:
          ThemeProvider.isMobile ? Colors.white : Colors.transparent,
      textTheme: TextTheme(
        displayMedium: headline2.copyWith(color: Colors.black),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: Colors.white70,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: colorToMaterial(Colors.white),
      scaffoldBackgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.white),
      inputDecorationTheme: getTextInputTheme(true),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: const Color.fromARGB(110, 82, 82, 82),
        unselectedIconTheme: const IconThemeData(color: Colors.white),
        unselectedLabelTextStyle: const TextStyle(color: Colors.white),
        selectedLabelTextStyle: const TextStyle(color: Colors.white),
        selectedIconTheme: IconThemeData(color: Colors.blueGrey.shade700),
        indicatorColor: Colors.white,
        useIndicator: true,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.grey.shade600,
        iconColor: Colors.white,
        textColor: Colors.white,
        style: ListTileStyle.drawer,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.disabled)) {
                return Colors.white70;
              }
              return Colors.white;
            },
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.disabled)) {
                return const Color.fromARGB(90, 78, 78, 78);
              }
              return Colors.blueGrey.shade700;
            },
          ),
        ),
      ),
      textTheme: darkTextTheme,
    );
  }

  static final darkTextTheme = TextTheme(
    headlineLarge: headline2.copyWith(color: Colors.white),
    titleMedium: const TextStyle(color: Colors.white), // TextField text!
    bodyMedium: const TextStyle(color: Colors.white),
  );

  Future<void> toggleTheme() async {
    final preferences = await SharedPreferences.getInstance();

    switch (state) {
      case ThemeMode.dark:
        state = ThemeMode.light;
        await preferences.setString('theme', 'light');
        break;
      case ThemeMode.light:
        state = ThemeMode.system;
        await preferences.setString('theme', 'system');
        break;
      default:
        state = ThemeMode.dark;
        await preferences.setString('theme', 'dark');
        break;
    }
  }

  void loadThemePreference() {
    SharedPreferences.getInstance().then((preferences) {
      if (preferences.containsKey('theme')) {
        final mode = preferences.getString('theme');

        switch (mode) {
          case 'dark':
            super.state = ThemeMode.dark;
            break;
          case 'light':
            super.state = ThemeMode.light;
            break;
          default:
            super.state = ThemeMode.system;
            break;
        }
      }
    });
  }
}
