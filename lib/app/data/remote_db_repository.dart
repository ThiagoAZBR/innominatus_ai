import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/domain/models/remoteDB/language.dart';
import 'package:innominatus_ai/app/domain/usecases/remote_db/save_field_of_study_with_subjects_db.dart';
import 'package:innominatus_ai/app/shared/app_constants/remote_db_constants.dart';
import 'package:innominatus_ai/app/shared/miscellaneous/exceptions.dart';

import '../domain/models/remoteDB/field_of_study_db.dart';
import '../domain/models/shared_fields_of_study.dart';
import '../domain/usecases/remote_db/get_fields_of_study_db.dart';
import '../domain/usecases/remote_db/get_subjects_db.dart';

abstract class RemoteDBRepository {
  Future<Either<Exception, SharedFieldsOfStudyModel>> getFieldsOfStudy(
    GetFieldsOfStudyDBParams params,
  );
  Future<Either<Exception, List<String>>> saveFieldOfStudyWithSubjects(
    SaveFieldOfStudyWithSubjectsDBParams params,
  );
  Future<Either<Exception, List<String>>> getSubjects(
    GetFieldOfStudyWithSubjectsDBParams params,
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
      return Right(_handleGetFieldsOfStudy(response, params.language));
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
              name: params.fieldOfStudyName.toLowerCase(),
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

  @override
  Future<Either<Exception, List<String>>> getSubjects(
    GetFieldOfStudyWithSubjectsDBParams params,
  ) async {
    try {
      final queryDoc = await firebaseFirestore
          .collection(RemoteDBConstants.languages)
          .where(RemoteDBFieldsConstants.name, isEqualTo: params.languageCode)
          .get();

      final doc = queryDoc.docs.first.reference;

      final fieldOfStudy = await doc
          .collection(RemoteDBConstants.fieldsOfStudy)
          .where(
            RemoteDBFieldsConstants.name,
            isEqualTo: params.fieldOfStudyName.toLowerCase(),
          )
          .get();
      return Right(_handleGetSubjects(fieldOfStudy));
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

List<String> _handleGetSubjects(
  QuerySnapshot<Map<String, dynamic>> querySnapshot,
) {
  try {
    final fieldOfStudyRemote = FieldOfStudyRemoteDB.fromMap(
      querySnapshot.docs.first.data(),
    );
    return fieldOfStudyRemote.allSubjects;
  } catch (e) {
    FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    throw UnexpectedException();
  }
}

SharedFieldsOfStudyModel _handleGetFieldsOfStudy(
  QuerySnapshot<Map<String, dynamic>> querySnapshot,
  String language,
) {
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
