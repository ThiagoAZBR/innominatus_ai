import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_color.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final Widget? floatingButton;

  const AppScaffold({
    Key? key,
    required this.child,
    this.floatingButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: child,
      ),
      floatingActionButton: floatingButton,
    );
  }
}
