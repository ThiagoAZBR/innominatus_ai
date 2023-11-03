import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/remote_db_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

class GetClassDB implements UseCase<String, GetClassDBParams> {
  final RemoteDBRepository remoteDBRepository;

  GetClassDB(this.remoteDBRepository);

  @override
  Future<Either<Exception, String>> call({
    required GetClassDBParams params,
  }) async {
    return await remoteDBRepository.getClassContent(params);
  }
}

class GetClassDBParams {
  final String languageCode;
  final String fieldOfStudyName;
  final String subjectName;
  final String className;

  GetClassDBParams({
    required this.languageCode,
    required this.fieldOfStudyName,
    required this.subjectName,
    required this.className,
  });
}
