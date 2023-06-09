import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/remote_db_repository.dart';
import 'package:innominatus_ai/app/domain/models/shared_subjects.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

class GetSubjectsDB implements UseCase<SharedSubjectsModel, NoParams> {
  final RemoteDBRepository remoteDBRepository;

  GetSubjectsDB(this.remoteDBRepository);

  @override
  Future<Either<Exception, SharedSubjectsModel>> call({
    required NoParams params,
  }) async {
    return await remoteDBRepository.getSubjects(params);
  }
}
