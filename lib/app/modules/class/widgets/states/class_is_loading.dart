import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_color.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

class ClassIsLoading extends StatelessWidget {
  const ClassIsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppColors.secondary,
            ),
            const SizedBox(height: 24),
            Text(
              'Estou criando sua aula!',
              style: AppTextStyles.interMedium(),
            ),
          ],
        ),
      ),
    );
  }
}
