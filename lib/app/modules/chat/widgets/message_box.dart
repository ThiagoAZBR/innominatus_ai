import 'package:flutter/material.dart';

import '../../../shared/themes/app_color.dart';

class MessageBox extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsets margin;

  const MessageBox({
    Key? key,
    required this.child,
    this.backgroundColor = AppColors.primary,
    this.margin = const EdgeInsets.only(bottom: 24),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.85,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      margin: margin,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: child,
      ),
    );
  }
}
