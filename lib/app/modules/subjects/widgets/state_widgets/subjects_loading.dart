import 'package:flutter/material.dart';

import '../../../../shared/themes/app_color.dart';

class SubjectsLoading extends StatelessWidget {
  const SubjectsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const LoadingPlaceholder(),
        const SizedBox(height: 32),
        Column(
          children: const <Widget>[
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
