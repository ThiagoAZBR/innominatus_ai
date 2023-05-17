import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/containers/app_container.dart';

import '../../domain/usecases/chat/create_chat_completion.dart';
import '../../modules/chat/controllers/chat_controller.dart';

class ChatContainer implements Dependencies {
  final I = GetIt.instance;
  @override
  void dispose() {
    I.unregister<ChatController>();
  }

  @override
  void setup() {
    I.registerLazySingleton(
      () => ChatController(
        I.get<AppController>(),
        I.get<CreateChatCompletion>(),
      ),
    );
  }
}
