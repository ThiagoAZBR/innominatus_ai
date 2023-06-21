import 'package:get_it/get_it.dart';

import '../../modules/subjects/controllers/subjects_controller.dart';
import '../core/app_controller.dart';
import 'app_container.dart';

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
