import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/core/app_controller.dart';
import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/create_chat_completion.dart';

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
      () => AppController(
        I.get<CreateChatCompletion>(),
      ),
    );
  }
}
