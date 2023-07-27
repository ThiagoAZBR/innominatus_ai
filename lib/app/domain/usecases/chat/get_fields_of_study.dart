import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

class GetFieldsOfStudyAI implements UseCase<List<String>, NoParams> {
  final ChatRepository chatRepository;

  GetFieldsOfStudyAI(this.chatRepository);

  @override
  Future<Either<Exception, List<String>>> call({
    required NoParams params,
  }) async {
    return await chatRepository.getFieldsOfStudy(params);
  }
}

class GetFieldsOfStudyParams {
  final String content;

  GetFieldsOfStudyParams({
    required this.content,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'content': content});

    return result;
  }
}
