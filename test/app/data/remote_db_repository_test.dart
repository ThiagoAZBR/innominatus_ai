import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/remote_db_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

void main() async {
  final firebaseInstance = FakeFirebaseFirestore();
  final RemoteDBRepository remoteDBRepository = FirebaseStoreRepository(
    firebaseInstance,
  );
  test('remote db repository must return Right', () async {
    final response =
        await remoteDBRepository.getFieldsOfStudy(const NoParams());

    expect(response, isA<Right>());
  });
}
