import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

class GetRoadmap implements UseCase<List<String>, GetRoadmapParams> {
  final ChatRepository chatRepository;

  GetRoadmap(this.chatRepository);

  @override
  Future<Either<Exception, List<String>>> call({
    required GetRoadmapParams params,
  }) async {
    return await chatRepository.getRoadmap(params);
  }
}

class GetRoadmapParams {
  final String content;

  GetRoadmapParams(this.content);

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'content': content});

    return result;
  }
}
