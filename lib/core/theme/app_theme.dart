import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.purple9,
        onPrimary: AppColors.purpleContrast,
        secondary: AppColors.purple3,
        onSecondary: AppColors.purple11,
        error: AppColors.error,
        onError: Colors.white,
        surface: AppColors.purple2,
        onSurface: Colors.black,
        outline: AppColors.purple7,
      ),
      scaffoldBackgroundColor: AppColors.purple1,
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.purple1,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.purple2,
        indicatorColor: AppColors.purple4,
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.purple9,
        onPrimary: AppColors.purpleContrast,
        secondary: AppColors.purple8,
        onSecondary: AppColors.purple12,
        error: AppColors.error,
        onError: Colors.white,
        surface: Color(0xFF1A1A1A),
        onSurface: Colors.white,
        outline: AppColors.purple8,
      ),
      scaffoldBackgroundColor: Colors.black,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1A1A1A),
        indicatorColor: AppColors.purple10,
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
