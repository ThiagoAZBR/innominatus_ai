import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_color.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

class AppDialog extends StatelessWidget {
  final String? title;
  final String content;
  final VoidCallback? onTap;

  const AppDialog({
    Key? key,
    this.title,
    required this.content,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title ?? 'Ops...',
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
            'Fechar',
            style: AppTextStyles.interMedium(color: AppColors.link),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
