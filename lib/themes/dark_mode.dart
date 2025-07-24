import 'package:flutter/material.dart';

ThemeData getDarkMode() {
  return ThemeData(
    colorScheme: const ColorScheme.dark(
      surface: Color(0xFF121212),
      primary: Color.fromARGB(255, 208, 173, 250),
      secondary: Color.fromARGB(255, 100, 100, 100),
      tertiary: Color.fromARGB(255, 143, 143, 143),
      inversePrimary: Color(0xFF3700B3),
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF121212),
  );
}
