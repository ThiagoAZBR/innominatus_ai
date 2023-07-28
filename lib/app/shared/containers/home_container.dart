import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/modules/home/controllers/home_controller.dart';
import 'package:innominatus_ai/app/shared/containers/app_container.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';

class HomeContainer implements Dependencies {
  final I = GetIt.instance;

  @override
  void dispose() {}

  @override
  void setup() {
    I.registerLazySingleton(
      () => HomeController(
        I.get<AppController>(),
      ),
    );
  }
}
