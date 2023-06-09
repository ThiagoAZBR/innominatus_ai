import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/shared/text_constants/remote_db_constants.dart';
import 'package:innominatus_ai/app/shared/miscellaneous/exceptions.dart';

import '../domain/models/shared_subjects.dart';
import '../domain/usecases/usecase.dart';

abstract class RemoteDBRepository {
  Future<Either<Exception, SharedSubjectsModel>> getSubjects(
    NoParams params,
  );
}

class FirebaseStoreRepository implements RemoteDBRepository {
  final FirebaseFirestore firebaseFirestore;

  FirebaseStoreRepository(this.firebaseFirestore);

  @override
  Future<Either<Exception, SharedSubjectsModel>> getSubjects(
      NoParams params) async {
    try {
      final response = await firebaseFirestore
          .collection(RemoteDBConstants.shared)
          .doc(RemoteDBConstants.subjects)
          .get();
      return Right(await _handleGetSubjects(response));
    } on FirebaseException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(EmptyCacheException());
    }
  }
}

Future<SharedSubjectsModel> _handleGetSubjects(
  DocumentSnapshot<Map<String, dynamic>> json,
) async {
  return SharedSubjectsModel.fromJson(json.data()!);
}
