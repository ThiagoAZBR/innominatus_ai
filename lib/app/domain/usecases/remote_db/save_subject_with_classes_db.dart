import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/remote_db_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

class SaveSubjectWithClassesRemoteDB
    implements UseCase<List<String>, SaveSubjectsWithClassesDBParams> {
  final RemoteDBRepository remoteDBRepository;

  SaveSubjectWithClassesRemoteDB(this.remoteDBRepository);

  @override
  Future<Either<Exception, List<String>>> call({
    required SaveSubjectsWithClassesDBParams params,
  }) async {
    return await remoteDBRepository.saveSubjectWithClasses(params);
  }
}

class SaveSubjectsWithClassesDBParams {
  final String languageCode;
  final String fieldOfStudyName;
  final String subjectName;
  final List<String> allClasses;

  SaveSubjectsWithClassesDBParams({
    required this.languageCode,
    required this.fieldOfStudyName,
    required this.subjectName,
    required this.allClasses,
  });
}