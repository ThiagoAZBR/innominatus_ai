import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/class/create_class_use_case.dart';
import 'package:innominatus_ai/app/domain/usecases/class/stream_create_class_use_case.dart';
import 'package:innominatus_ai/app/modules/class/controllers/class_controller.dart';
import 'package:innominatus_ai/app/shared/containers/app_container.dart';

class ClassContainer implements Dependencies {
  final I = GetIt.instance;

  @override
  void dispose() {
    I.unregister<CreateClassUseCase>();
    I.unregister<StreamCreateClassUseCase>();
    I.unregister<ClassController>();
  }

  @override
  void setup() {
    I.registerLazySingleton(
      () => CreateClassUseCase(
        I.get<ChatRepository>(),
      ),
    );
    I.registerLazySingleton(
      () => StreamCreateClassUseCase(
        I.get<ChatRepository>(),
      ),
    );
    I.registerLazySingleton(
      () => ClassController(
        I.get<CreateClassUseCase>(),
        I.get<StreamCreateClassUseCase>(),
      ),
    );
  }
}
