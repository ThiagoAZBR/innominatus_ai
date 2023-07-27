import 'package:get_it/get_it.dart';

import '../../modules/subjects/controllers/fields_of_study_controller.dart';
import '../core/app_controller.dart';
import 'app_container.dart';

class FieldsOfStudyContainer implements Dependencies {
  final I = GetIt.instance;
  @override
  void dispose() {
    I.unregister<FieldsOfStudyController>();
  }

  @override
  void setup() {
    I.registerLazySingleton(
      () => FieldsOfStudyController(
        I.get<AppController>(),
      ),
    );
  }
}
