import 'package:flutter/material.dart';

ThemeData getDarkMode() {
  return ThemeData(
    colorScheme: const ColorScheme.dark(
      surface: Color.fromARGB(255, 26, 26, 26),
      primary: Color.fromARGB(255, 255, 255, 255),
      secondary: Color.fromARGB(255, 92, 92, 92),
      tertiary: Color.fromARGB(255, 46, 46, 46),
      inversePrimary: Color(0xFF0D47A1),
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: Color(0xFFF1FAEE),
  );
}
