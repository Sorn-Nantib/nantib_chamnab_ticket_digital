import 'package:flutter/material.dart';

class AppTheme {
  // Invitation-style palette (lavender, purple, white)
  static const Color primaryPurple = Color(0xFF6B4E9E);
  static const Color deepPurple = Color(0xFF4A3B6B);
  static const Color lavender = Color(0xFFB8A9D4);
  static const Color lightLavender = Color(0xFFE8E0F0);
  static const Color backgroundCream = Color(0xFFF8F5FC);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF2D2438);
  static const Color textMuted = Color(0xFF6B5B7A);

  /// Alias for textDark (for ticket/legacy screens).
  static const Color textPrimary = textDark;

  /// Alias for textMuted (for ticket/legacy screens).
  static const Color textSecondary = textMuted;
  static const Color petalPink = Color(0xFFE8B4C4);
  static const Color heartPink = Color(0xFFF0C0D0);

  /// Lighter purple for names / script text (invitation-style)
  static const Color namePurple = Color(0xFF7B6B9E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        brightness: Brightness.light,
        primary: primaryPurple,
      ),
      scaffoldBackgroundColor: backgroundCream,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textDark,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: cardWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
