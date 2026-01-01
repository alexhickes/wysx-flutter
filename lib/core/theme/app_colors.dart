import 'package:flutter/material.dart';

class AppColors {
  // Purple Palette (Radix-like)
  static const Color purple1 = Color(0xFFFEFCFF);
  static const Color purple2 = Color(0xFFFCF7FF);
  static const Color purple3 = Color(0xFFF9EBFF);
  static const Color purple4 = Color(0xFFF4DFFF);
  static const Color purple5 = Color(0xFFEED1FF);
  static const Color purple6 = Color(0xFFE5BFFF);
  static const Color purple7 = Color(0xFFD9A6FE);
  static const Color purple8 = Color(0xFFCA86F9);
  static const Color purple9 = Color(0xFF8A00C4);
  static const Color purple10 = Color(0xFF7A00B2);
  static const Color purple11 = Color(0xFF9319CD);
  static const Color purple12 = Color(0xFF4C056D);

  // Alpha variants (approximate based on hex provided)
  static const Color purpleA1 = Color(0x03AA00FF);
  static const Color purpleA2 = Color(0x08A000FF);
  static const Color purpleA3 = Color(0x14B300FF);
  static const Color purpleA4 = Color(0x20A800FF);
  static const Color purpleA5 = Color(0x2EA100FF);
  static const Color purpleA6 = Color(0x409800FF);
  static const Color purpleA7 = Color(0x599300FD);
  static const Color purpleA8 = Color(0x799000F3);
  static const Color purpleA9 = Color(0xFF8A00C4); // Same as solid
  static const Color purpleA10 = Color(0xFF7A00B2); // Same as solid
  static const Color purpleA11 = Color(0xE68700C8);
  static const Color purpleA12 = Color(0xFA48006A);

  static const Color purpleContrast = Colors.white;
  static const Color purpleSurface = Color(0xCCFBF5FF);
  static const Color purpleIndicator = purple9;
  static const Color purpleTrack = purple9;

  // Semantic Colors
  static const Color primary = purple9;
  static const Color onPrimary = Colors.white;
  static const Color secondary = purple3;
  static const Color onSecondary = purple11;
  static const Color background = Colors.white; // Or purple1 for tinted
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFBA1A1A);

  // Dark Mode (Inferred or standard dark theme adjustments)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
}
