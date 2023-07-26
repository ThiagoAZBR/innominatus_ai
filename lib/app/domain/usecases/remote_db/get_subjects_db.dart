import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/remote_db_repository.dart';
import 'package:innominatus_ai/app/domain/models/shared_fields_of_study.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

class GetSubjectsDB implements UseCase<SharedFieldsOfStudyModel, NoParams> {
  final RemoteDBRepository remoteDBRepository;

  GetSubjectsDB(this.remoteDBRepository);

  @override
  Future<Either<Exception, SharedFieldsOfStudyModel>> call({
    required NoParams params,
  }) async {
    return await remoteDBRepository.getSubjects(params);
  }
}
