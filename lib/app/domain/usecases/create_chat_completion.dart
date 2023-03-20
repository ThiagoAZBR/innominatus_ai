import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

import '../models/chat_completion.dart';

class CreateChatCompletion
    implements UseCase<ChatCompletionModel, CreateChatCompletionParam> {
  final ChatRepository chatRepository;

  CreateChatCompletion(this.chatRepository);

  @override
  Future<Either<Exception, ChatCompletionModel>> call({
    required CreateChatCompletionParam params,
  }) async {
    return await chatRepository.createChatCompletion(params);
  }
}

class CreateChatCompletionParam {
  final String content;

  CreateChatCompletionParam(this.content);

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'content': content});

    return result;
  }
}
