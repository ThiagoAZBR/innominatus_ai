import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/modules/chat/controllers/chat_controller.dart';
import 'package:innominatus_ai/app/modules/home/controllers/home_controller.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/subjects_controller.dart';
import 'package:innominatus_ai/app/modules/subjects/fields_of_study_page.dart';
import 'package:innominatus_ai/app/modules/subtopics/controllers/sub_topics_controller.dart';
import 'package:innominatus_ai/app/modules/subtopics/sub_topics_page.dart';
import 'package:innominatus_ai/app/shared/containers/chat_container.dart';
import 'package:innominatus_ai/app/shared/containers/home_container.dart';
import 'package:innominatus_ai/app/shared/containers/subjects_container.dart';
import 'package:innominatus_ai/app/shared/containers/subtopics_container.dart';

import '../../modules/chat/chat_page.dart';
import '../../modules/home/home_page.dart';
import '../../modules/splash/splash_page.dart';
import 'app_routes.dart';

class AppRouting {
  final I = GetIt.I;

  Map<String, Widget Function(BuildContext)> routes() => {
        AppRoutes.splashPage: (_) => const SplashPage(),
        AppRoutes.homePage: (_) {
          _handleHomePageDependencies();
          return HomePage(
            appController: I.get(),
          );
        },
        AppRoutes.chatPage: (_) {
          _handleChatPageDependencies();
          return ChatPage(
            chatController: I.get(),
          );
        },
        AppRoutes.fieldsOfStudyPage: (_) {
          _handleSubjectsPageDependencies();
          return FieldsOfStudyPage(
            fieldsOfStudyController: I.get<FieldsOfStudyController>(),
          );
        },
        AppRoutes.subjectsPage: (_) {
          _handleSubTopicsPageDependencies();
          return SubTopicsPage(
            controller: I.get<SubTopicsController>(),
          );
        }
      };

  // Dependencies Handlers
  void _handleHomePageDependencies() {
    if (!I.isRegistered<HomeController>()) {
      HomeContainer().setup();
    }
  }

  void _handleChatPageDependencies() {
    if (!I.isRegistered<ChatController>()) {
      ChatContainer().setup();
    }
  }

  void _handleSubjectsPageDependencies() {
    if (!I.isRegistered<FieldsOfStudyController>()) {
      FieldsOfStudyContainer().setup();
    }
  }

  void _handleSubTopicsPageDependencies() {
    if (!I.isRegistered<SubTopicsController>()) {
      SubTopicsContainer().setup();
    }
  }
}
