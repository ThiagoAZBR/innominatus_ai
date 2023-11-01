import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/remote_db_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

class GetFieldOfStudyWithSubjects
    implements UseCase<List<String>, GetFieldOfStudyWithSubjectsDBParams> {
  final RemoteDBRepository remoteDBRepository;

  GetFieldOfStudyWithSubjects(this.remoteDBRepository);

  @override
  Future<Either<Exception, List<String>>> call({
    required GetFieldOfStudyWithSubjectsDBParams params,
  }) async {
    return await remoteDBRepository.getSubjects(params);
  }
}

class GetFieldOfStudyWithSubjectsDBParams {
  final String languageCode;
  final String fieldOfStudyName;

  GetFieldOfStudyWithSubjectsDBParams({
    required this.languageCode,
    required this.fieldOfStudyName,
  });
}
