import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/modules/class/controllers/class_controller.dart';
import 'package:innominatus_ai/app/shared/containers/app_container.dart';

class ClassContainer implements Dependencies {
  final I = GetIt.instance;

  @override
  void dispose() {
    I.unregister<ClassController>();
  }

  @override
  void setup() {
    I.registerLazySingleton(
      () => ClassController(),
    );
  }
}
