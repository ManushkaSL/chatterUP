import 'package:flutter/material.dart';

ThemeData getLightMode() {
  return ThemeData(
    colorScheme: const ColorScheme.light(
      surface: Color.fromARGB(255, 218, 218, 218),
      primary: Color.fromARGB(255, 0, 0, 0),
      secondary: Color.fromARGB(255, 134, 134, 134),
      tertiary: Colors.white,
      inversePrimary: Color(0xFF0D47A1),
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: Color(0xFFF1FAEE),
  );
}
