import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/data/remote_db_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/class/create_class_use_case.dart';
import 'package:innominatus_ai/app/domain/usecases/class/stream_create_class_use_case.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/get_class_db.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/save_class_db.dart';
import 'package:innominatus_ai/app/modules/class/controllers/class_controller.dart';
import 'package:innominatus_ai/app/shared/containers/app_container.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';

class ClassContainer implements Dependencies {
  final I = GetIt.instance;

  @override
  void dispose() {
    I.unregister<CreateClassUseCase>();
    I.unregister<StreamCreateClassUseCase>();
    I.unregister<ClassController>();
    I.unregister<GetClassDB>();
    I.unregister<SaveClassDB>();
  }

  @override
  void setup() {
    I.registerLazySingleton(
      () => GetClassDB(
        I.get<RemoteDBRepository>(),
      ),
    );
    I.registerLazySingleton(
      () => SaveClassDB(
        I.get<RemoteDBRepository>(),
      ),
    );
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
        I.get<AppController>(),
        I.get<CreateClassUseCase>(),
        I.get<StreamCreateClassUseCase>(),
        I.get<GetClassDB>(),
        I.get<SaveClassDB>(),
      ),
    );
  }
}
