import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/remote_db_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

class SaveClassDB implements UseCase<String, SaveClassDBParams> {
  final RemoteDBRepository remoteDBRepository;

  SaveClassDB(this.remoteDBRepository);

  @override
  Future<Either<Exception, String>> call({
    required SaveClassDBParams params,
  }) async {
    return await remoteDBRepository.saveClassContent(params);
  }
}

class SaveClassDBParams {
  final String languageCode;
  final String fieldOfStudyName;
  final String subjectName;
  final String className;
  final String content;
  final String? audioUrl;

  SaveClassDBParams({
    required this.languageCode,
    required this.fieldOfStudyName,
    required this.subjectName,
    required this.className,
    required this.content,
    this.audioUrl,
  });
}
