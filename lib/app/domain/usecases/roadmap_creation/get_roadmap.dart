import 'package:fpdart/fpdart.dart';

import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

class GetRoadmapUseCase implements UseCase<List<String>, GetRoadmapParams> {
  final ChatRepository chatRepository;

  GetRoadmapUseCase(this.chatRepository);

  @override
  Future<Either<Exception, List<String>>> call({
    required GetRoadmapParams params,
  }) async {
    return await chatRepository.getRoadmap(params);
  }
}

class GetRoadmapParams {
  final String topic;
  final String language;

  GetRoadmapParams(
    this.topic,
    this.language,
  );

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'content': topic});

    return result;
  }
}
