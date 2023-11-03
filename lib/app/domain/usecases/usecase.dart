import 'package:fpdart/fpdart.dart';

abstract class UseCase<Entity, Params> {
  Future<Either<Exception, Entity>> call({required Params params});
}

class NoParams {
  const NoParams();
}
