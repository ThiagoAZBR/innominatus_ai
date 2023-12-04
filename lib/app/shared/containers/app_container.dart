import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/data/remote_db_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/chat/create_chat_completion.dart';
import 'package:innominatus_ai/app/domain/usecases/fields_of_study/get_fields_of_study.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/get_fields_of_study_db.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/get_subjects_db.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/save_field_of_study_with_subjects_db.dart';
import 'package:innominatus_ai/app/domain/usecases/roadmap_creation/get_roadmap.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';

import '../localDB/localdb.dart';

abstract class Dependencies {
  void setup();
  void dispose();
}

class AppContainer implements Dependencies {
  final I = GetIt.instance;
  @override
  void dispose() {}

  @override
  void setup() {
    I.registerLazySingleton(
      () => Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 115),
          receiveTimeout: const Duration(seconds: 115),
        ),
      ),
    );
    I.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
    I.registerSingleton(PrefsImpl(I.get()));
    I.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(
        I.get<Dio>(),
      ),
    );
    I.registerLazySingleton<RemoteDBRepository>(
      () => FirebaseStoreRepository(
        I.get<FirebaseFirestore>(),
      ),
    );
    I.registerLazySingleton(
      () => CreateChatCompletion(
        I.get<ChatRepository>(),
      ),
    );
    I.registerLazySingleton(
      () => GetFieldsOfStudyAI(
        I.get<ChatRepository>(),
      ),
    );
    I.registerLazySingleton(
      () => GetFieldsOfStudyDB(
        I.get<RemoteDBRepository>(),
      ),
    );
    I.registerLazySingleton(
      () => GetRoadmapUseCase(
        I.get<ChatRepository>(),
      ),
    );
    I.registerLazySingleton(
      () => SaveFieldOfStudyWithSubjects(
        I.get<RemoteDBRepository>(),
      ),
    );
    I.registerLazySingleton(
      () => GetFieldOfStudyWithSubjects(
        I.get<RemoteDBRepository>(),
      ),
    );
    I.registerSingleton(
      AppController(
        getRoadmap: I.get<GetRoadmapUseCase>(),
        getFieldsOfStudyAI: I.get<GetFieldsOfStudyAI>(),
        saveFieldOfStudyWithSubjects: I.get<SaveFieldOfStudyWithSubjects>(),
        getFieldOfStudyWithSubjects: I.get<GetFieldOfStudyWithSubjects>(),
        prefs: I.get<PrefsImpl>(),
      ),
    );
  }
}
