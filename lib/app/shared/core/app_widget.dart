import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/shared/core/app_routing.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb.dart';
import 'package:innominatus_ai/app/shared/text_constants/localdb_constants.dart';
import 'package:innominatus_ai/app/shared/routes/app_routes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = GetIt.I.get<PrefsImpl>();
    final hasShowedSplashScreen = prefs.get(
      LocalDBConstants.hasShowedSplashScreen,
    );
    return MaterialApp(
      routes: AppRouting().routes(),
      initialRoute: hasShowedSplashScreen != null
          ? AppRoutes.homePage
          : AppRoutes.splashPage,
      debugShowCheckedModeBanner: false,
    );
  }
}
