import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/domain/models/remoteDB/language.dart';
import 'package:innominatus_ai/app/shared/app_constants/remote_db_constants.dart';
import 'package:innominatus_ai/app/shared/miscellaneous/exceptions.dart';

import '../domain/models/shared_fields_of_study.dart';
import '../domain/usecases/remote_db/get_fields_of_study_db.dart';

abstract class RemoteDBRepository {
  Future<Either<Exception, SharedFieldsOfStudyModel>> getFieldsOfStudy(
    GetFieldsOfStudyDBParams params,
  );
}

class FirebaseStoreRepository implements RemoteDBRepository {
  final FirebaseFirestore firebaseFirestore;

  FirebaseStoreRepository(this.firebaseFirestore);

  @override
  Future<Either<Exception, SharedFieldsOfStudyModel>> getFieldsOfStudy(
    GetFieldsOfStudyDBParams params,
  ) async {
    try {
      final response = await firebaseFirestore
          .collection(RemoteDBConstants.languages)
          .where(
            RemoteDBFieldsConstants.name,
            isEqualTo: params.language,
          )
          .get();
      return Right(await _handleGetFieldsOfStudy(response, params.language));
    } on FirebaseException catch (e) {
      return Left(e);
    } on MissingLanguageCacheException catch (e) {
      return Left(e);
    } on UnexpectedException catch (e) {
      return Left(e);
    }
  }
}

Future<SharedFieldsOfStudyModel> _handleGetFieldsOfStudy(
  QuerySnapshot<Map<String, dynamic>> querySnapshot,
  String language,
) async {
  try {
    if (querySnapshot.docs.isEmpty) {
      throw MissingLanguageCacheException();
    }
    return SharedFieldsOfStudyModel.fromLanguageModel(
      LanguageModel.fromMap(querySnapshot.docs.first.data()),
    );
  } on MissingLanguageCacheException {
    throw MissingLanguageCacheException();
  } catch (e) {
    throw UnexpectedException();
  }
}
