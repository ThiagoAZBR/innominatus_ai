import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/domain/models/remoteDB/language.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/save_subjects_db.dart';
import 'package:innominatus_ai/app/shared/app_constants/remote_db_constants.dart';
import 'package:innominatus_ai/app/shared/miscellaneous/exceptions.dart';

import '../domain/models/remoteDB/field_of_study_db.dart';
import '../domain/models/shared_fields_of_study.dart';
import '../domain/usecases/remote_db/get_fields_of_study_db.dart';

abstract class RemoteDBRepository {
  Future<Either<Exception, SharedFieldsOfStudyModel>> getFieldsOfStudy(
    GetFieldsOfStudyDBParams params,
  );
  Future<Either<Exception, List<String>>> saveFieldOfStudyWithSubjects(
    SaveFieldOfStudyWithSubjectsDBParams params,
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

  @override
  Future<Either<Exception, List<String>>> saveFieldOfStudyWithSubjects(
    SaveFieldOfStudyWithSubjectsDBParams params,
  ) async {
    try {
      final queryDoc = await firebaseFirestore
          .collection(RemoteDBConstants.languages)
          .where(RemoteDBFieldsConstants.name, isEqualTo: params.languageCode)
          .get();

      final doc = queryDoc.docs.first.reference;

      await doc.collection(RemoteDBConstants.fieldsOfStudy).add(
            FieldOfStudyRemoteDB(
              name: params.fieldOfStudyName,
              allSubjects: params.allSubjects,
            ).toMap(),
          );

      return Right(params.allSubjects);
    } on FirebaseException catch (e) {
      return Left(e);
    } on MissingLanguageCacheException catch (e) {
      return Left(e);
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return Left(UnexpectedException());
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
    FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    throw UnexpectedException();
  }
}
