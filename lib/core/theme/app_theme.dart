import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Color Palette
  static const Color saffronOrange = Color(0xFFF28C28);
  static const Color deepNavy = Color(0xFF0B1830);
  static const Color midNavy = Color(0xFF1C3A56);
  static const Color cream = Color(0xFFFAF6EE);
  static const Color indiaGreen = Color(0xFF1F9D6B);
  static const Color brightGreen = Color(0xFF2FB586);
  static const Color bodyText = Color(0xFF12263A);
  static const Color mutedText = Color(0xFF3D4C5C);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color dividerColor = Color(0xFFE2DDD3);

  // High contrast ranking colors
  static const Color rankBest = saffronOrange;
  static const Color rankBetter = indiaGreen;
  static const Color rankGood = Color(0xFF4A6572);

  // Minimum accessible touch target size
  static const double minTouchTargetSize = 56.0;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      primaryColor: saffronOrange,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: saffronOrange,
        onPrimary: Colors.white,
        secondary: deepNavy,
        onSecondary: Colors.white,
        tertiary: indiaGreen,
        onTertiary: Colors.white,
        error: Color(0xFFBA1A1A),
        onError: Colors.white,
        background: cream,
        onBackground: bodyText,
        surface: surfaceWhite,
        onSurface: bodyText,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.domine(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: deepNavy,
          height: 1.25,
        ),
        displayMedium: GoogleFonts.domine(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: deepNavy,
          height: 1.3,
        ),
        titleLarge: GoogleFonts.domine(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: deepNavy,
          height: 1.35,
        ),
        titleMedium: GoogleFonts.nunitoSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: bodyText,
        ),
        bodyLarge: GoogleFonts.nunitoSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: bodyText,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: bodyText,
          height: 1.45,
        ),
        bodySmall: GoogleFonts.nunitoSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: mutedText,
        ),
        labelLarge: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: deepNavy,
        foregroundColor: cream,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.domine(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: cream,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(minTouchTargetSize),
          backgroundColor: saffronOrange,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(minTouchTargetSize),
          foregroundColor: deepNavy,
          side: const BorderSide(color: midNavy, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceWhite,
        elevation: 3,
        shadowColor: deepNavy.withOpacity(0.12),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: dividerColor, width: 1.2),
        ),
      ),
    );
  }
}
