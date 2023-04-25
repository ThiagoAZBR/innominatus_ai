import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/core/text_constants/remote_db_constants.dart';
import 'package:innominatus_ai/app/data/remote_db_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';

void main() async {
  final firebaseInstance = FakeFirebaseFirestore();
  await firebaseInstance
      .collection(RemoteDBConstants.shared)
      .doc(RemoteDBConstants.subjects)
      .set({
    'items': [
      "Ciência de Dados",
      "Inteligência Artificial",
      "Desenvolvimento de Software",
      "Engenharia de Software",
      "Segurança da Informação",
      "Design de Interfaces",
      "Marketing Digital",
      "Gestão de Projetos",
      "Administração de Empresas",
      "Contabilidade",
      "Engenharia Civil",
      "Engenharia Mecânica",
      "Engenharia Elétrica",
      "Engenharia de Produção",
      "Medicina",
      "Enfermagem",
      "Fisioterapia",
      "Psicologia",
      "Direito",
      "Relações Internacionais",
      "Ciências Políticas",
      "Jornalismo",
      "Publicidade e Propaganda",
      "Arquitetura",
      "Design Gráfico",
      "Artes Visuais",
      "Música",
      "Teatro",
      "Cinema",
      "Literatura",
      "História",
      "Geografia",
      "Biologia",
      "Química",
      "Física",
      "Matemática",
      "Educação Física",
      "Nutrição",
      "Administração Hospitalar",
    ],
    'subtopics': {},
  });
  final RemoteDBRepository remoteDBRepository = FirebaseStoreRepository(
    firebaseInstance,
  );
  test('remote db repository must return Right', () async {
    final response = await remoteDBRepository.getSubjects(const NoParams());

    expect(response, isA<Right>());
  });
}
