import 'package:flutter/material.dart';

import '../../../../shared/themes/app_color.dart';
import '../../../../shared/themes/app_text_styles.dart';

class StudyPlanIsLoading extends StatelessWidget {
  const StudyPlanIsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.secondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Carregando informações do aplicativo...',
            style: AppTextStyles.interMedium(),
          ),
        ],
      ),
    );
  }
}
