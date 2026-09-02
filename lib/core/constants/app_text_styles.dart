import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shared text styles. Change sizes or weights here to update typography later.
class AppTextStyles {
  AppTextStyles._();

  /// Screen and recipe titles.
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  /// Section headers and supporting titles.
  static const TextStyle subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  /// Default body copy for descriptions and lists.
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  /// Secondary / helper body copy.
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: AppColors.textSecondary,
  );

  /// Large type for hands-free cooking mode (readable from a distance).
  static const TextStyle cookingMode = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: AppColors.textPrimary,
  );
}
