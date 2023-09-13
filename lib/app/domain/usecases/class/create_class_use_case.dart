import 'package:fpdart/src/either.dart';
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

  CreateClassParams({required this.className});

   Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'content': className});

    return result;
  }
}