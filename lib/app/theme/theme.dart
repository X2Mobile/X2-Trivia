import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x2trivia/app/theme/colors.dart';

final class X2TriviaTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: X2TriviaColors.blue,
    ),
    filledButtonTheme: const FilledButtonThemeData(),
    buttonTheme: const ButtonThemeData(
      buttonColor: X2TriviaColors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
    inputDecorationTheme: const InputDecorationTheme(filled: true, border: OutlineInputBorder(), fillColor: X2TriviaColors.lightGray),
  );

  static const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}
