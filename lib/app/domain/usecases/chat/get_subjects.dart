import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

class GetSubjectsAI implements UseCase<List<String>, NoParams> {
  final ChatRepository chatRepository;

  GetSubjectsAI(this.chatRepository);

  @override
  Future<Either<Exception, List<String>>> call({
    required NoParams params,
  }) async {
    return await chatRepository.getSubjects(params);
  }
}

class GetSubjectsParams {
  final String content;

  GetSubjectsParams({
    required this.content,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'content': content});

    return result;
  }
}
