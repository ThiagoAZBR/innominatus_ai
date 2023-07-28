import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/modules/study_plan/controllers/study_plan_controller.dart';
import 'package:innominatus_ai/app/shared/containers/app_container.dart';

class StudyPlanContainer implements Dependencies {
  final I = GetIt.instance;
  @override
  void dispose() {
    I.unregister<StudyPlanController>();
  }

  @override
  void setup() {
    I.registerLazySingleton(() => StudyPlanController());
  }
}
