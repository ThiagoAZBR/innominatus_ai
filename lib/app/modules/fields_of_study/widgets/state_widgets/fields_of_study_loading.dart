import 'package:flutter/material.dart';

import '../../../../shared/themes/app_color.dart';

class FieldsOfStudyLoading extends StatelessWidget {
  const FieldsOfStudyLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        LoadingPlaceholder(),
        SizedBox(height: 32),
        Column(
          children: <Widget>[
            LoadingPlaceholder(),
            SizedBox(height: 8),
            LoadingPlaceholder(),
            SizedBox(height: 8),
            LoadingPlaceholder(),
            SizedBox(height: 8),
            LoadingPlaceholder(),
            SizedBox(height: 8),
            LoadingPlaceholder(),
            SizedBox(height: 8),
            LoadingPlaceholder(),
            SizedBox(height: 8),
            LoadingPlaceholder(),
            SizedBox(height: 8),
            LoadingPlaceholder(),
            SizedBox(height: 8),
            LoadingPlaceholder(),
            SizedBox(height: 8),
            LoadingPlaceholder(),
            SizedBox(height: 8),
          ],
        )
      ],
    );
  }
}

class LoadingPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  const LoadingPlaceholder({
    Key? key,
    this.width = double.infinity,
    this.height = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
