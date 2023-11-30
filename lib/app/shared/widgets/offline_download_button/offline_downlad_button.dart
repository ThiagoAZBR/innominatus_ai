import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_color.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

class OfflineDownloadButton extends StatelessWidget {
  final VoidCallback onTap;

  const OfflineDownloadButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.download_for_offline_rounded,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 4),
          Text(
            'Baixar conteúdos para acessar offline',
            style: AppTextStyles.interSmall(
                color: AppColors.link,
                textDecoration: TextDecoration.underline),
          ),
        ],
      ),
    );
  }
}
