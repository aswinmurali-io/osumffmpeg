import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeProvider extends StateNotifier<ThemeMode> {
  ThemeProvider() : super(ThemeMode.system);

  /// Converts any [color] of type [Colors] to [MaterialColor].
  static MaterialColor colorToMaterial(Color color) =>
      MaterialColor(color.value, getSwatch(color));

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
      50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
      100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
      200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
      300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
      400: (hslColor.withLightness(lightness + lowStep)).toColor(),
      500: (hslColor.withLightness(lightness)).toColor(),
      600: (hslColor.withLightness(lightness - highStep)).toColor(),
      700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
      800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
      900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
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

  static ThemeData get lightTheme {
    return ThemeData(
      // backgroundColor: Colors.white54,
      primarySwatch: primarySwatch,
      inputDecorationTheme: getTextInputTheme(false),
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: TextTheme(
        headline2: headline2.copyWith(color: Colors.black),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: Colors.white70,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: colorToMaterial(Colors.black),
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.white70;
              }
              return Colors.white;
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(MaterialState.disabled)) {
                return const Color.fromARGB(90, 78, 78, 78);
              }
              return Colors.blueGrey.shade700;
            },
          ),
        ),
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
