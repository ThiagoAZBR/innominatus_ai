import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/data/remote_db_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/chat/create_chat_completion.dart';
import 'package:innominatus_ai/app/domain/usecases/chat/get_roadmap.dart';
import 'package:innominatus_ai/app/domain/usecases/chat/get_subjects.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/get_subjects_db.dart';

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
      () => Dio(),
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
      () => GetSubjectsAI(
        I.get<ChatRepository>(),
      ),
    );
    I.registerLazySingleton(
      () => GetSubjectsDB(
        I.get<RemoteDBRepository>(),
      ),
    );
    I.registerLazySingleton(
      () => GetRoadmap(
        I.get<ChatRepository>(),
      ),
    );
    I.registerSingleton(
      AppController(
        getSubjectsDB: I.get<GetSubjectsDB>(),
        getRoadmap: I.get<GetRoadmap>(),
        prefs: I.get<PrefsImpl>(),
      ),
    );
  }
}
