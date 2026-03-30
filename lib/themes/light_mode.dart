import 'package:flutter/material.dart';

ThemeData getLightMode() {
  return ThemeData(
    colorScheme: const ColorScheme.light(
      // Background for surfaces (cards, containers)
      surface: Color(0xFFF5F5F5), // Off-white background
      // Main text & icon color
      primary: Color(0xFF000000), // Premium Black
      // Accent color for buttons, highlights, etc.
      secondary: Color(0xFFFFFFFF), // Pure White
      // Used for containers like input fields
      tertiary: Color(0xFFFFFFFF), // White
      // Often used for loading indicators or attention
      inversePrimary: Color(0xFF333333), // Dark Gray
      // Error color
      error: Color(0xFFD32F2F),

      // On surface text
      onSurface: Color(0xFF000000),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFF000000),
    ),
    useMaterial3: true,

    // Whole app background
    scaffoldBackgroundColor: Color(0xFFF5F5F5),

    // App bar styling with premium black/white theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF),
      elevation: 1,
      iconTheme: IconThemeData(color: Color(0xFF000000)),
      titleTextStyle: TextStyle(
        color: Color(0xFF000000),
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    ),

    // Button styling - Premium look
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF000000),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 2,
      ),
    ),

    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD0D0D0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF000000), width: 2),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
    ),
  );
}
