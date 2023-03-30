import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/core/app_routing.dart';
import 'package:innominatus_ai/app/shared/routes/app_routes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: AppRouting().routes(),
      initialRoute: AppRoutes.splashPage,
      debugShowCheckedModeBanner: false,
    );
  }
}
