import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/core/app_controller.dart';
import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/create_chat_completion.dart';
import 'package:innominatus_ai/app/domain/usecases/get_roadmap.dart';
import 'package:innominatus_ai/app/domain/usecases/get_subjects.dart';

import '../../shared/localDB/localdb.dart';

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
    I.registerSingleton(PrefsImpl(I.get()));
    I.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(
        I.get<Dio>(),
      ),
    );
    I.registerLazySingleton(
      () => CreateChatCompletion(
        I.get<ChatRepository>(),
      ),
    );
    I.registerLazySingleton(
      () => GetSubjects(
        I.get<ChatRepository>(),
      ),
    );
    I.registerLazySingleton(
      () => GetRoadmap(
        I.get<ChatRepository>(),
      ),
    );
    I.registerSingleton(
      AppController(
        getSubjects: I.get<GetSubjects>(),
        getRoadmap: I.get<GetRoadmap>(),
        prefs: I.get<PrefsImpl>(),
      ),
    );
  }
}
