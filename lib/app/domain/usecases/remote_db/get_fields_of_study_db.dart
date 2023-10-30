import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/remote_db_repository.dart';
import 'package:innominatus_ai/app/domain/models/shared_fields_of_study.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

class GetFieldsOfStudyDB
    implements UseCase<SharedFieldsOfStudyModel, GetFieldsOfStudyDBParams> {
  final RemoteDBRepository remoteDBRepository;

  GetFieldsOfStudyDB(this.remoteDBRepository);

  @override
  Future<Either<Exception, SharedFieldsOfStudyModel>> call({
    required GetFieldsOfStudyDBParams params,
  }) async {
    return await remoteDBRepository.getFieldsOfStudy(params);
  }
}

class GetFieldsOfStudyDBParams {
  final String language;

  GetFieldsOfStudyDBParams({required this.language});
}
