import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/remote_db_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

class GetClassesRemoteDB implements UseCase<List<String>, GetClassesDBParams> {
  final RemoteDBRepository remoteDBRepository;

  GetClassesRemoteDB(this.remoteDBRepository);

  @override
  Future<Either<Exception, List<String>>> call({
    required GetClassesDBParams params,
  }) async {
    return await remoteDBRepository.getClasses(params);
  }
}

class GetClassesDBParams {
  final String languageCode;
  final String fieldOfStudyName;
  final String subjectName;

  GetClassesDBParams({
    required this.languageCode,
    required this.fieldOfStudyName,
    required this.subjectName,
  });
}
