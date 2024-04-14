import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/utils/language_utils.dart';

import '../../themes/app_color.dart';
import '../../themes/app_text_styles.dart';

class AddNewContentConfirmation extends StatelessWidget {
  final VoidCallback onTap;
  final String contentToBeAdded;
  const AddNewContentConfirmation({
    Key? key,
    required this.onTap,
    required this.contentToBeAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 32, top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            LocalizationUtils.I(context).appWidgetsConfirmPersonalizedContent,
            style: AppTextStyles.interBig(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            contentToBeAdded,
            style: AppTextStyles.interMedium(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              fixedSize: const Size(
                double.infinity,
                50,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                LocalizationUtils.I(context).appWidgetsContinue,
                style: AppTextStyles.interMedium(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              fixedSize: const Size(
                double.infinity,
                50,
              ),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppColors.lightWhite),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                LocalizationUtils.I(context).classBack,
                style: AppTextStyles.interMedium(color: AppColors.lightBlack),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
