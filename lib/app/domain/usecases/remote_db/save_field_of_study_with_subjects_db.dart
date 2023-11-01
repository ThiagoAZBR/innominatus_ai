import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/remote_db_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

class SaveFieldOfStudyWithSubjects
    implements UseCase<List<String>, SaveFieldOfStudyWithSubjectsDBParams> {
  final RemoteDBRepository remoteDBRepository;

  SaveFieldOfStudyWithSubjects(this.remoteDBRepository);

  @override
  Future<Either<Exception, List<String>>> call({
    required SaveFieldOfStudyWithSubjectsDBParams params,
  }) async {
    return await remoteDBRepository.saveFieldOfStudyWithSubjects(params);
  }
}

class SaveFieldOfStudyWithSubjectsDBParams {
  final String languageCode;
  final String fieldOfStudyName;
  final List<String> allSubjects;

  SaveFieldOfStudyWithSubjectsDBParams({
    required this.languageCode,
    required this.fieldOfStudyName,
    required this.allSubjects,
  });
}
