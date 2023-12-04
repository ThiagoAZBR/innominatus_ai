import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/get_fields_of_study_db.dart';

import '../../modules/fields_of_study/controllers/fields_of_study_controller.dart';
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
        I.get<GetFieldsOfStudyDB>(),
        I.get<AppController>(),
      ),
    );
  }
}
