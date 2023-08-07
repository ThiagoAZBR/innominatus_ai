import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

class ClassesError extends StatelessWidget {
  const ClassesError({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 32),
        Text(
          'Ocorreu um erro na criação de aulas',
          style: AppTextStyles.interMedium(),
        ),
      ],
    );
  }
}
