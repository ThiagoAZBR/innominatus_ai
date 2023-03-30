import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/core/app_container.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/subjects_controller.dart';

class SubjectsContainer implements Dependencies {
  final I = GetIt.instance;
  @override
  void dispose() {}

  @override
  void setup() {
    I.registerLazySingleton(() => SubjectsController());
  }
}
