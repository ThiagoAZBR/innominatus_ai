import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/create_chat_completion.dart';
import 'package:innominatus_ai/app/modules/chat/controllers/chat_controller.dart';

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
      () => ChatController(
        I.get<CreateChatCompletion>(),
      ),
    );
  }
}
