import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/shared/network/app_urls.dart';

import '../domain/models/chat_completion.dart';
import '../domain/usecases/create_chat_completion.dart';
import '../shared/miscellaneous/exceptions.dart';

abstract class ChatRepository {
  Future<Either<Exception, ChatCompletionModel>> createChatCompletion(
    CreateChatCompletionParam params,
  );
}

class ChatRepositoryImpl implements ChatRepository {
  final Dio dio;

  ChatRepositoryImpl(this.dio);

  @override
  Future<Either<Exception, ChatCompletionModel>> createChatCompletion(
    CreateChatCompletionParam params,
  ) async {
    try {
      if (kDebugMode) {
        return Left(HomologResponse());
      }
      final Map data = params.toMap();
      final response = await dio.post(
        AppUrls.createChatCompletion,
        data: data,
      );
      return Right(_handleChatResponse(response));
    } on DioError catch (e) {
      return Left(e);
    } on UnexpectedException catch (e) {
      return Left(e);
    }
  }
}

// Handlers
ChatCompletionModel _handleChatResponse(Response response) {
  if (response.statusCode == 200) {
    return ChatCompletionModel.fromJson(response.data);
  }

  throw UnexpectedException();
}
