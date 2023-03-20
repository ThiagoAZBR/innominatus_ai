import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/shared/miscellaneous/app_routes.dart';

import 'modules/chat/chat_page.dart';
import 'modules/home/home_page.dart';
import 'modules/splash/splash_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        AppRoutes.splashPage: (context) => SplashPage(
              appController: GetIt.I.get(),
            ),
        AppRoutes.homePage: (context) => HomePage(
              appController: GetIt.I.get(),
            ),
        AppRoutes.chatPage: (context) => ChatPage(
              appController: GetIt.I.get(),
            )
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
