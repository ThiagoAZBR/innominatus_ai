import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

import '../../themes/app_color.dart';

class AppButton extends StatelessWidget {
  final Widget? child;
  final String? text;
  final VoidCallback onTap;
  final double? height;

  const AppButton({
    Key? key,
    this.child,
    this.text,
    required this.onTap,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        fixedSize: Size(
          MediaQuery.sizeOf(context).width,
          height ?? 64,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: child ??
          Text(
            text ?? 'Continuar',
            style: AppTextStyles.interMedium(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
    );
  }
}
