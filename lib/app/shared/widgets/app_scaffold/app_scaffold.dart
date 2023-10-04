import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_color.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Widget? floatingButton;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    Key? key,
    required this.child,
    this.backgroundColor = AppColors.primary,
    this.floatingButton,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: child,
      ),
      floatingActionButton: floatingButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
