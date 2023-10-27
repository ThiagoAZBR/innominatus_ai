import 'package:fpdart/fpdart.dart';

import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

class CreateClassUseCase implements UseCase<String, CreateClassParams> {
  final ChatRepository chatRepository;

  CreateClassUseCase(this.chatRepository);

  @override
  Future<Either<Exception, String>> call({
    required CreateClassParams params,
  }) async {
    return await chatRepository.createClass(params);
  }
}

class CreateClassParams {
  final String className;
  final String subject;
  final String language;

  CreateClassParams({
    required this.className,
    required this.subject,
    required this.language,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'content': className});

    return result;
  }
}
