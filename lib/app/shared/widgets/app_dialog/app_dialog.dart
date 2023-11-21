import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_color.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

import '../../utils/language_utils.dart';

class AppDialog extends StatelessWidget {
  final String? title;
  final bool hasCallToAction;
  final VoidCallback? callToActionOnTap;
  final String? callToActionLabel;
  final String content;
  final VoidCallback? closeOnTap;

  const AppDialog({
    Key? key,
    this.title,
    this.hasCallToAction = false,
    this.callToActionOnTap,
    this.callToActionLabel,
    required this.content,
    this.closeOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title ?? LocalizationUtils.I(context).appWidgetsOps,
        style: AppTextStyles.interBig(fontWeight: FontWeight.bold),
      ),
      content: Text(
        content,
        style: AppTextStyles.interMedium(),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            textStyle: AppTextStyles.interMedium(),
          ),
          child: Text(
            LocalizationUtils.I(context).appWidgetsClose,
            style: AppTextStyles.interMedium(color: AppColors.link),
          ),
          onPressed: () => closeOnTap ?? Navigator.pop(context),
        ),
        Visibility(
          visible: hasCallToAction,
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: AppTextStyles.interMedium(),
            ),
            onPressed: callToActionOnTap,
            child: Text(
              callToActionLabel ??
                  LocalizationUtils.I(context).appWidgetsContinue,
              style: AppTextStyles.interMedium(color: AppColors.link),
            ),
          ),
        ),
      ],
    );
  }
}
