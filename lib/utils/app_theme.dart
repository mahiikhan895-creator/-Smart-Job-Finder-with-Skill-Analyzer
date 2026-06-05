// lib/utils/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF0A2540);
  static const Color accent = Color(0xFF00D4FF);
  static const Color success = Color(0xFF00C896);
  static const Color warning = Color(0xFFFFB347);
  static const Color error = Color(0xFFFF5A5F);
  static const Color surface = Color(0xFFF8FAFB);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF0A2540);
  static const Color textSecondary = Color(0xFF6B7A90);
  static const Color divider = Color(0xFFE8EDF2);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: accent,
        surface: surface,
        error: error,
      ),
      scaffoldBackgroundColor: surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardTheme(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: divider),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFEEF2FF),
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF4B6EF5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'applied':
        return const Color(0xFF4B6EF5);
      case 'interview_scheduled':
        return warning;
      case 'accepted':
        return success;
      case 'rejected':
        return error;
      default:
        return textSecondary;
    }
  }

  static Color skillCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'technical':
        return const Color(0xFF4B6EF5);
      case 'soft':
        return const Color(0xFF00C896);
      default:
        return const Color(0xFFFF9F43);
    }
  }

  static Color difficultyColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return success;
      case 'intermediate':
        return warning;
      case 'advanced':
        return error;
      default:
        return textSecondary;
    }
  }
}