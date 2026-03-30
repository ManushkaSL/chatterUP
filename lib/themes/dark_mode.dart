import 'package:flutter/material.dart';

ThemeData getDarkMode() {
  return ThemeData(
    colorScheme: const ColorScheme.dark(
      surface: Color(0xFF121212), // Very dark (almost black)
      primary: Color(0xFFFFFFFF), // White text/icons
      secondary: Color(0xFF1A1A1A), // Dark gray
      tertiary: Color(0xFF2A2A2A), // Lighter dark gray
      inversePrimary: Color(0xFFE0E0E0), // Light gray
      error: Color(0xFFD32F2F),
      onSurface: Color(0xFFE0E0E0), // Light text
      onPrimary: Color(0xFF000000), // Dark text on white
      onSecondary: Color(0xFFE0E0E0), // Light text on dark
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF121212),

    // App bar styling with premium black/white theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      elevation: 1,
      iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
      titleTextStyle: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    ),

    // Button styling - Premium look
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 2,
      ),
    ),

    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: 2),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
    ),
  );
}
