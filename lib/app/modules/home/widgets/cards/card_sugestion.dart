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
    return Container(
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
        padding: const EdgeInsets.all(12.0),
        child: Text(
          suggestion,
          style: AppTextStyles.interMedium(),
        ),
      ),
    );
  }
}
