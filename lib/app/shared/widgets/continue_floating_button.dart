import 'package:flutter/material.dart';

import '../themes/app_color.dart';
import '../themes/app_text_styles.dart';
import '../utils/language_utils.dart';

class ContinueFloatingButton extends StatelessWidget {
  final VoidCallback onTap;

  const ContinueFloatingButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 64,
        right: 12,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: AppColors.secondary,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                LocalizationUtils.I(context).appWidgetsContinue,
                style: AppTextStyles.interMedium(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
