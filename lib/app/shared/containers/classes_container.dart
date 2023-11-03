import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/data/remote_db_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/get_classes_db.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/save_subject_with_classes_db.dart';
import 'package:innominatus_ai/app/domain/usecases/roadmap_creation/get_roadmap.dart';
import 'package:innominatus_ai/app/modules/classes/controllers/classes_controller.dart';
import 'package:innominatus_ai/app/shared/containers/app_container.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';

class ClassesContainer implements Dependencies {
  final I = GetIt.instance;

  @override
  void dispose() {
    I.unregister<ClassesController>();
    I.unregister<GetClassesRemoteDB>();
    I.unregister<SaveSubjectWithClassesRemoteDB>();
  }

  @override
  void setup() {
    I.registerLazySingleton(
      () => GetClassesRemoteDB(
        I.get<RemoteDBRepository>(),
      ),
    );
    I.registerLazySingleton(
      () => SaveSubjectWithClassesRemoteDB(
        I.get<RemoteDBRepository>(),
      ),
    );
    I.registerLazySingleton(
      () => ClassesController(
        getRoadmapUseCase: I.get<GetRoadmapUseCase>(),
        appController: I.get<AppController>(),
        getClassesRemoteDB: I.get<GetClassesRemoteDB>(),
        saveSubjectWithClassesRemoteDB: I.get<SaveSubjectWithClassesRemoteDB>(),
      ),
    );
  }
}
