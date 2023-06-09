import 'package:innominatus_ai/app/modules/subjects/controllers/subjects_controller.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:rx_notifier/rx_notifier.dart';

class SubTopicsController {
  final SubjectsController subjectsController;
  final RxList<String> subTopics$ = RxList();

  SubTopicsController(this.subjectsController);

  // Getters and Setters
  AppController get appController => subjectsController.appController;
}
