import 'package:flutter/material.dart';

import '../../themes/app_color.dart';
import '../../themes/app_text_styles.dart';

class AddPersonalizedContent extends StatelessWidget {
  final VoidCallback onTap;
  final TextEditingController textEditingController;
  final String title;
  const AddPersonalizedContent({
    Key? key,
    required this.onTap,
    required this.textEditingController,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TextField(
          controller: textEditingController,
          maxLines: 2,
          minLines: 1,
          style: AppTextStyles.interBig(),
          decoration: InputDecoration(
            hintText: title,
            border: InputBorder.none,
            suffixIcon: IconButton(
              onPressed: onTap,
              icon: const Icon(
                Icons.send_rounded,
                color: AppColors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
