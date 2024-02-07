import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

import '../../../../shared/utils/language_utils.dart';

class FieldsOfStudyError extends StatelessWidget {
  const FieldsOfStudyError({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 72,
        left: 32,
        right: 32,
      ),
      child: Text(
        // ignore: prefer_interpolation_to_compose_strings
        LocalizationUtils.I(context).fieldsOfStudyErrorMessage + '\n\n=(',
        style: AppTextStyles.interVeryBig(),
      ),
    );
  }
}
