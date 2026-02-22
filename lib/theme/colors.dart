import 'package:flutter/material.dart';

class TeaTheme {
  static const Color primaryGreen = Color(0xFF2E7D32); // Darker green for text/icons
  static const Color lightGreen = Color(0xFFC8E6C9); // Background green
  static const Color buttonGreen = Color(0xFF43A047); // Standard tea-leaf green for buttons
  static const Color accentGreen = Color(0xFF1B5E20); // Darker accent

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        onPrimary: Colors.white,
        secondary: buttonGreen,
        onSecondary: Colors.white,
        surface: Colors.white,
        background: lightGreen.withOpacity(0.3),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen),
        ),
        labelStyle: const TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
      ),
    );
  }
}
