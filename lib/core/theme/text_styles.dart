import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class TextStyles {
  static TextTheme get lightTextTheme => const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppDimensions.fontH1,
          fontWeight: FontWeight.w700,
          color: AppColors.grey900,
        ),
        titleLarge: TextStyle(
          fontSize: AppDimensions.fontXl,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        titleMedium: TextStyle(
          fontSize: AppDimensions.fontLg,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        bodyLarge: TextStyle(
          fontSize: AppDimensions.fontLg,
          fontWeight: FontWeight.w400,
          color: AppColors.grey900,
        ),
        bodyMedium: TextStyle(
          fontSize: AppDimensions.fontMd,
          fontWeight: FontWeight.w400,
          color: AppColors.grey700,
        ),
        bodySmall: TextStyle(
          fontSize: AppDimensions.fontSm,
          fontWeight: FontWeight.w400,
          color: AppColors.grey500,
        ),
        labelLarge: TextStyle(
          fontSize: AppDimensions.fontMd,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      );

  static TextTheme get darkTextTheme => const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppDimensions.fontH1,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
        titleLarge: TextStyle(
          fontSize: AppDimensions.fontXl,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        titleMedium: TextStyle(
          fontSize: AppDimensions.fontLg,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: AppDimensions.fontLg,
          fontWeight: FontWeight.w400,
          color: AppColors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: AppDimensions.fontMd,
          fontWeight: FontWeight.w400,
          color: AppColors.grey300,
        ),
        bodySmall: TextStyle(
          fontSize: AppDimensions.fontSm,
          fontWeight: FontWeight.w400,
          color: AppColors.grey500,
        ),
        labelLarge: TextStyle(
          fontSize: AppDimensions.fontMd,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryLight,
        ),
      );
}
