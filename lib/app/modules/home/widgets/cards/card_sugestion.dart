import 'package:flutter/material.dart';

import '../../../../shared/themes/app_color.dart';
import '../../../../shared/themes/app_text_styles.dart';

class CardSuggestion extends StatelessWidget {
  final String suggestion;
  const CardSuggestion({
    super.key,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              offset: const Offset(0, 4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 16,
            right: 24,
            left: 24,
          ),
          child: Center(
            child: Text(
              suggestion,
              style: AppTextStyles.interMedium(fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
