import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/core/containers/chat_container.dart';
import 'package:innominatus_ai/app/core/containers/home_container.dart';
import 'package:innominatus_ai/app/core/containers/subjects_container.dart';
import 'package:innominatus_ai/app/modules/chat/controllers/chat_controller.dart';
import 'package:innominatus_ai/app/modules/home/controllers/home_controller.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/subjects_controller.dart';
import 'package:innominatus_ai/app/modules/subjects/subjects_page.dart';

import '../modules/chat/chat_page.dart';
import '../modules/home/home_page.dart';
import '../modules/splash/splash_page.dart';
import '../shared/routes/app_routes.dart';

class AppRouting {
  final I = GetIt.I;

  Map<String, Widget Function(BuildContext)> routes() => {
        AppRoutes.splashPage: (context) => SplashPage(
              appController: I.get(),
            ),
        AppRoutes.homePage: (context) {
          _handleHomePageDependencies();
          return HomePage(
            appController: I.get(),
          );
        },
        AppRoutes.chatPage: (context) {
          _handleChatPageDependencies();
          return ChatPage(
            chatController: I.get(),
          );
        },
        AppRoutes.subjectsPage: (context) {
          _handleSubjectsPageDependencies();
          return SubjectsPage(
            subjectsController: I.get(),
          );
        }
      };

  // Dependencies Handlers
  void _handleHomePageDependencies() {
    if (!I.isRegistered<HomeController>()) {
      HomeContainer().setup();
    }
  }

  void _handleSubjectsPageDependencies() {
    if (!I.isRegistered<SubjectsController>()) {
      SubjectsContainer().setup();
    }
  }

  void _handleChatPageDependencies() {
    if (!I.isRegistered<ChatController>()) {
      ChatContainer().setup();
    }
  }
}
