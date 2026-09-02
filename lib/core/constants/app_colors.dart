import 'package:flutter/material.dart';

/// Brand colors for JUBU. Change values here to restyle the whole app later.
class AppColors {
  AppColors._();

  /// Warm orange used for buttons, highlights, and brand accents.
  static const Color primary = Color(0xFFE85D04);

  /// Darker orange for pressed states and emphasis.
  static const Color primaryDark = Color(0xFFBB4D03);

  /// Lighter orange for chips and subtle fills.
  static const Color primaryLight = Color(0xFFFF9F4A);

  /// Herb green used as the secondary brand color.
  static const Color secondary = Color(0xFF4F7942);

  /// Soft green for secondary backgrounds and success-adjacent UI.
  static const Color secondaryLight = Color(0xFFDCE8D7);

  /// Warm off-white page background.
  static const Color background = Color(0xFFF7F3EE);

  /// Cream card surface (neutral, food-friendly).
  static const Color cardBackground = Color(0xFFFFFBF7);

  /// Muted beige for dividers and nested surfaces.
  static const Color surfaceMuted = Color(0xFFEDE6DC);

  /// Amber used to call out local ingredient swaps.
  static const Color swapHighlight = Color(0xFFE9A825);

  /// Pale amber fill behind swap callout boxes.
  static const Color swapHighlightLight = Color(0xFFFFF3D6);

  static const Color textPrimary = Color(0xFF2B2118);
  static const Color textSecondary = Color(0xFF6B5E52);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color error = Color(0xFFC0392B);
}
