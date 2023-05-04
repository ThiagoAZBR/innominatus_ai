import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

import '../../../shared/themes/app_color.dart';

class SubjectCard extends StatelessWidget {
  final String subject;
  final String description;
  final bool isCardSelected;

  const SubjectCard({
    Key? key,
    required this.subject,
    required this.description,
    this.isCardSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        border: isCardSelected
            ? Border.all(
                color: AppColors.secondary,
                width: 1.5,
              )
            : null,
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Name of the Topic
            Text(
              subject,
              style: AppTextStyles.interMedium(),
            ),
          ],
        ),
      ),
    );
  }
}
