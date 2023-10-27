import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/chat/create_chat_completion.dart';
import 'package:innominatus_ai/app/domain/usecases/class/create_class_use_case.dart';
import 'package:innominatus_ai/app/domain/usecases/roadmap_creation/get_roadmap.dart';

void main() {
  final Dio dio = Dio();
  final ChatRepository chatRepository = ChatRepositoryImpl(dio);

  group('Get Roadmap', () {
    test('GetRoadmap must Return Right', () async {
      final response = await chatRepository.getRoadmap(
        GetRoadmapParams('UX', 'pt'),
      );

      expect(response, isA<Right>());
    });
  });

  group('Chat Answer', () {
    test('Chat repository must Return Right', () async {
      final response = await chatRepository.createChatCompletion(
        CreateChatCompletionParam('O que é uma IA?'),
      );

      expect(response, isA<Right>());
    });
  });

  group('Must return a detailed class', () {
    test('Must return String from createClass', () async {
      final response = await chatRepository.createClass(
        CreateClassParams(
            className: 'Behaviorismo', subject: 'Psicologia', language: 'pt'),
      );

      expect(response, isA<Right>());
    });
  });
}
