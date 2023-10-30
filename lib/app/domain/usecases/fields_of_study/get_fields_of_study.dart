import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

import '../../models/shared_fields_of_study.dart';

class GetFieldsOfStudyAI
    implements UseCase<SharedFieldsOfStudyModel, GetFieldsOfStudyParams> {
  final ChatRepository chatRepository;

  GetFieldsOfStudyAI(this.chatRepository);

  @override
  Future<Either<Exception, SharedFieldsOfStudyModel>> call({
    required GetFieldsOfStudyParams params,
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
