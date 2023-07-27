import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/shared/containers/app_container.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';

import '../../modules/subjects/controllers/subjects_controller.dart';

class SubjectsContainer implements Dependencies {
  final I = GetIt.instance;

  @override
  void dispose() {
    I.unregister<SubjectsController>();
  }

  @override
  void setup() {
    I.registerLazySingleton(
      () => SubjectsController(
        I.get<AppController>(),
      ),
    );
  }
}
