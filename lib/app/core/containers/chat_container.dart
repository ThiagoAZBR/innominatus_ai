import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/core/app_container.dart';

import '../../domain/usecases/create_chat_completion.dart';
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
        I.get<CreateChatCompletion>(),
      ),
    );
  }
}
