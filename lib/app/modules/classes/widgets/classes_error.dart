import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

import '../../../shared/utils/language_utils.dart';

class ClassesError extends StatelessWidget {
  const ClassesError({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            // ignore: prefer_interpolation_to_compose_strings
            LocalizationUtils.I(context).classesErrorMessage + '\n\n=(',
            style: AppTextStyles.interVeryBig(),
          ),
        ),
      ],
    );
  }
}
