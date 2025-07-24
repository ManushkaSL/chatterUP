import 'package:flutter/material.dart';

ThemeData getLightMode() {
  return ThemeData(
    colorScheme: const ColorScheme.light(
      // Background for surfaces (cards, containers)
      surface: Color(0xFFF8F9FA),

      // Main text & icon color
      primary: Color(0xFF1A1A1A), // Dark gray instead of pure black

      // Accent color for buttons, highlights, etc.
      secondary: Color(0xFF007BFF), // A pleasant, not-too-saturated blue

      // Used for containers like input fields
      tertiary: Color(0xFFFFFFFF),

      // Often used for loading indicators or attention
      inversePrimary: Color(0xFF0D47A1), // Deep blue
    ),
    useMaterial3: true,

    // Whole app background
    scaffoldBackgroundColor: Color(0xFFF1F3F6),
  );
}
