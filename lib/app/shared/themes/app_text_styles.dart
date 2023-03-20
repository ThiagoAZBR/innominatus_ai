import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTextStyles {
  static TextStyle interLittle({
    Color color = AppColors.textColor,
    FontWeight fontWeight = FontWeight.normal,
  }) =>
      TextStyle(
        fontSize: 14,
        fontFamily: 'inter',
        fontWeight: fontWeight,
        color: color,
      );

  static TextStyle interMedium({
    Color color = AppColors.textColor,
    FontWeight fontWeight = FontWeight.normal,
  }) =>
      TextStyle(
        fontSize: 16,
        fontFamily: 'inter',
        fontWeight: fontWeight,
        color: color,
      );

  static TextStyle interBig({
    Color color = AppColors.textColor,
    FontWeight fontWeight = FontWeight.normal,
  }) =>
      TextStyle(
        fontSize: 20,
        fontFamily: 'inter',
        fontWeight: fontWeight,
        color: color,
      );

  static TextStyle interVeryBig({
    Color color = AppColors.textColor,
    FontWeight fontWeight = FontWeight.normal,
  }) =>
      TextStyle(
        fontSize: 24,
        fontFamily: 'inter',
        fontWeight: fontWeight,
        color: color,
      );
}
