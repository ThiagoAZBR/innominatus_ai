import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../themes/app_color.dart';

class ShimmerCards extends StatelessWidget {
  const ShimmerCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: const Column(
        children: <Widget>[
          _ShimmerCard(),
          SizedBox(height: 32),
          _ShimmerCard(),
          SizedBox(height: 32),
          _ShimmerCard(),
          SizedBox(height: 32),
          _ShimmerCard(),
          SizedBox(height: 32),
          _ShimmerCard(),
          SizedBox(height: 32),
          _ShimmerCard(),
          SizedBox(height: 32),
          _ShimmerCard(),
        ],
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
