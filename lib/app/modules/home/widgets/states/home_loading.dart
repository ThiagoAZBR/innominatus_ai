import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';
import 'package:innominatus_ai/app/shared/utils/language_utils.dart';

import '../../../../shared/themes/app_color.dart';

class HomeLoading extends StatelessWidget {
  const HomeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
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
              LocalizationUtils.I(context).homeLoadAppInfo,
              style: AppTextStyles.interMedium(),
            ),
          ],
        ),
      ),
    );
  }
}
