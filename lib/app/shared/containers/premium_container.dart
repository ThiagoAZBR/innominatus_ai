import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/modules/premium/controllers/premium_controller.dart';
import 'package:innominatus_ai/app/shared/containers/app_container.dart';

class PremiumContainer implements Dependencies {
  final I = GetIt.I;

  @override
  void dispose() {
    I.unregister<PremiumController>();
  }

  @override
  void setup() {
    I.registerLazySingleton(
      () => PremiumController(),
    );
  }
}
