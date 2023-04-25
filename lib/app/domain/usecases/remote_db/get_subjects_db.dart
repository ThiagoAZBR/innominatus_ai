import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/remote_db_repository.dart';
import 'package:innominatus_ai/app/domain/models/subjects.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

class GetSubjectsDB implements UseCase<SubjectsModel, NoParams> {
  final RemoteDBRepository remoteDBRepository;

  GetSubjectsDB(this.remoteDBRepository);

  @override
  Future<Either<Exception, SubjectsModel>> call({
    required NoParams params,
  }) async {
    return await remoteDBRepository.getSubjects(params);
  }
}
