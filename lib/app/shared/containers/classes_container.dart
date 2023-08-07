import 'package:innominatus_ai/app/modules/classes/controllers/classes_controller.dart';
import 'package:innominatus_ai/app/shared/containers/app_container.dart';
import 'package:get_it/get_it.dart';

class ClassesContainer implements Dependencies {
  final I = GetIt.instance;
  
  @override
  void dispose() {
    I.unregister<ClassesController>();
  }

  @override
  void setup() {
    I.registerLazySingleton(() => ClassesController());
  }
}
