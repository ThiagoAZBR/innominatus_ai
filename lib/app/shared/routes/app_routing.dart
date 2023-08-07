import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/modules/chat/controllers/chat_controller.dart';
import 'package:innominatus_ai/app/modules/classes/classes_page.dart';
import 'package:innominatus_ai/app/modules/classes/controllers/classes_controller.dart';
import 'package:innominatus_ai/app/modules/fields_of_study/controllers/fields_of_study_controller.dart';
import 'package:innominatus_ai/app/modules/fields_of_study/fields_of_study_page.dart';
import 'package:innominatus_ai/app/modules/home/controllers/home_controller.dart';
import 'package:innominatus_ai/app/modules/study_plan/controllers/study_plan_controller.dart';
import 'package:innominatus_ai/app/modules/study_plan/study_plan_page.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/subjects_controller.dart';
import 'package:innominatus_ai/app/modules/subjects/subjects_page.dart';
import 'package:innominatus_ai/app/shared/containers/chat_container.dart';
import 'package:innominatus_ai/app/shared/containers/classes_container.dart';
import 'package:innominatus_ai/app/shared/containers/fields_of_study_container.dart';
import 'package:innominatus_ai/app/shared/containers/home_container.dart';
import 'package:innominatus_ai/app/shared/containers/study_plan_container.dart';
import 'package:innominatus_ai/app/shared/containers/subjects_container.dart';

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
            controller: I.get(),
          );
        },
        AppRoutes.chatPage: (_) {
          _handleChatPageDependencies();
          return ChatPage(
            chatController: I.get(),
          );
        },
        AppRoutes.fieldsOfStudyPage: (_) {
          _handleFieldsOfStudyPageDependencies();
          return FieldsOfStudyPage(
            fieldsOfStudyController: I.get<FieldsOfStudyController>(),
          );
        },
        AppRoutes.subjectsPage: (_) {
          _handleSubjectsPageDependencies();
          return SubjectsPage(
            controller: I.get<SubjectsController>(),
          );
        },
        AppRoutes.studyPlanPage: (_) {
          _handleStudyPlanPageDependencies();
          return StudyPlanPage(controller: I.get<StudyPlanController>());
        },
        AppRoutes.classesPage: (_) {
          _handleClassesPageDependencies();
          return ClassesPage(controller: I.get<ClassesController>());
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

  void _handleFieldsOfStudyPageDependencies() {
    if (!I.isRegistered<FieldsOfStudyController>()) {
      FieldsOfStudyContainer().setup();
    }
  }

  void _handleSubjectsPageDependencies() {
    if (!I.isRegistered<SubjectsController>()) {
      SubjectsContainer().setup();
    }
  }

  void _handleStudyPlanPageDependencies() {
    if (!I.isRegistered<StudyPlanController>()) {
      StudyPlanContainer().setup();
    }
  }

  void _handleClassesPageDependencies() {
    if (!I.isRegistered<ClassesController>()) {
      ClassesContainer().setup();
    }
  }
}
