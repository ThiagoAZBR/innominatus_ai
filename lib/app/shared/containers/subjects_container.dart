import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/shared/containers/app_container.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';

import '../../modules/subtopics/controllers/sub_topics_controller.dart';

class SubjectsContainer implements Dependencies {
  final I = GetIt.instance;

  @override
  void dispose() {
    I.unregister<SubTopicsController>();
  }

  @override
  void setup() {
    I.registerLazySingleton(
      () => SubTopicsController(
        I.get<AppController>(),
      ),
    );
  }
}
