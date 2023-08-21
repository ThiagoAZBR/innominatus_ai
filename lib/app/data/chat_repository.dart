import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:innominatus_ai/app/domain/usecases/class/create_class_use_case.dart';
import 'package:innominatus_ai/app/domain/usecases/fields_of_study/get_fields_of_study.dart';
import 'package:innominatus_ai/app/domain/usecases/roadmap_creation/get_roadmap.dart';
import 'package:innominatus_ai/app/domain/usecases/usecase.dart';
import 'package:innominatus_ai/app/shared/app_constants/app_constants.dart';
import 'package:innominatus_ai/app/shared/network/app_urls.dart';

import '../domain/models/chat_completion.dart';
import '../domain/usecases/chat/create_chat_completion.dart';
import '../shared/miscellaneous/exceptions.dart';

abstract class ChatRepository {
  Future<Either<Exception, ChatCompletionModel>> createChatCompletion(
    CreateChatCompletionParam params,
  );
  Future<Either<Exception, List<String>>> getRoadmap(
    GetRoadmapParams params,
  );
  Future<Either<Exception, List<String>>> getFieldsOfStudy(
    NoParams params,
  );
  Future<Either<Exception, String>> createClass(CreateClassParams params);
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
        kDebugMode
            ? AppUrls.createChatCompletionHomolog
            : AppUrls.createChatCompletionProduction,
        data: data,
      );
      return Right(_handleChatResponse(response));
    } on DioError catch (e) {
      return Left(e);
    } on UnexpectedException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<String>>> getRoadmap(
    GetRoadmapParams params,
  ) async {
    try {
      final Map data = GetRoadmapParams(
        AppConstants.getRoadmap(params.topic),
      ).toMap();
      final response = await dio.post(
        kDebugMode
            ? AppUrls.createChatCompletionHomolog
            : AppUrls.createChatCompletionProduction,
        data: data,
      );
      return Right(_handleGetRoadmapResponse(response));
    } on DioError catch (e) {
      return Left(e);
    } on UnexpectedException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<String>>> getFieldsOfStudy(
    NoParams params,
  ) async {
    try {
      final Map data = GetFieldsOfStudyParams(
        content: AppConstants.getFieldsOfStudy,
      ).toMap();
      final response = await dio.post(
        kDebugMode
            ? AppUrls.createChatCompletionHomolog
            : AppUrls.createChatCompletionProduction,
        data: data,
      );
      return Right(_handleGetFieldsOfStudyResponse(response));
    } on DioError catch (e) {
      return Left(e);
    } on UnexpectedException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, String>> createClass(
    CreateClassParams params,
  ) async {
    try {
      final Map data = CreateClassParams(
        className: AppConstants.createClass(params.className),
      ).toMap();

      final response = await dio.post(
        AppUrls.createChatCompletionProduction,
        data: data,
      );

      return Right(_handleCreateClassResponse(response));
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

List<String> _handleGetRoadmapResponse(Response response) {
  if (response.statusCode == 200) {
    ChatCompletionModel chatCompletionModel = ChatCompletionModel.fromJson(
      response.data,
    );
    String content =
        chatCompletionModel.choices.first.message.content.replaceAll('\n', '');
    final int startIndex = content.indexOf('[');
    final int endIndex = content.lastIndexOf(']');
    content = content.substring(startIndex, endIndex + 1);
    final List data = jsonDecode(content);
    return data.map((e) => e['content'].toString()).toList();
  }

  throw UnexpectedException();
}

List<String> _handleGetFieldsOfStudyResponse(Response response) {
  if (response.statusCode == 200) {
    ChatCompletionModel chatCompletionModel = ChatCompletionModel.fromJson(
      response.data,
    );
    String content =
        chatCompletionModel.choices.first.message.content.replaceAll('\n', '');
    final int startIndex = content.indexOf('[');
    final int endIndex = content.lastIndexOf(']');
    content = content.substring(startIndex, endIndex + 1);
    final List data = jsonDecode(content);
    return data.map((e) => e.toString()).toList();
  }

  throw UnexpectedException();
}

String _handleCreateClassResponse(Response response) {
  if (response.statusCode == 200) {
    ChatCompletionModel chatCompletionModel =
        ChatCompletionModel.fromJson(response.data);

    String content = chatCompletionModel.choices.first.message.content;

    return content;
  }

  throw UnexpectedException();
}
