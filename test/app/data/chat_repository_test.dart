import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/create_chat_completion.dart';

void main() {
  final Dio dio = Dio();
  final ChatRepository chatRepository = ChatRepositoryImpl(dio);
  test('Chat repository must Return Right', () async {
    final response = await chatRepository.createChatCompletion(
      CreateChatCompletionParam('O que é uma IA?'),
    );

    expect(response, isA<Right>());
  });
}
