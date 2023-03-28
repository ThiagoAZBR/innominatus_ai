import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../modules/chat/chat_page.dart';
import '../modules/home/home_page.dart';
import '../modules/splash/splash_page.dart';
import '../shared/miscellaneous/app_routes.dart';

class AppRouting {
  final Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.splashPage: (context) => SplashPage(
          appController: GetIt.I.get(),
        ),
    AppRoutes.homePage: (context) => HomePage(
          appController: GetIt.I.get(),
        ),
    AppRoutes.chatPage: (context) => ChatPage(
          appController: GetIt.I.get(),
        )
  };
}
