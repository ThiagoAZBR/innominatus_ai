import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
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
  Either<Exception, Future<http.StreamedResponse>> streamCreateClass(
    CreateClassParams params,
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
        AppUrls.createChatCompletionProduction,
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
        AppConstants.getRoadmap(params.topic, params.language),
        params.language,
      ).toMap();
      final response = await dio.post(
        AppUrls.createChatCompletionProduction,
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
        AppUrls.createChatCompletionProduction,
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
        className: AppConstants.createClass(params.className, params.language),
        subject: params.subject,
        language: params.language,
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

  @override
  Either<Exception, Future<http.StreamedResponse>> streamCreateClass(
    CreateClassParams params,
  ) {
    try {
      final data = CreateClassParams(
        className: AppConstants.createClass(params.className, params.language),
        subject: params.subject,
        language: params.language,
      );

      final classNameEncoded = base64Encode(utf8.encode(data.className));
      http.Client _client = http.Client();

      var request = http.Request(
          "GET",
          Uri.parse(
            AppUrls.streamCreateChatCompletionProduction + classNameEncoded,
          ));

      request.headers["Cache-Control"] = "no-cache";
      request.headers["Accept"] = "text/event-stream";

      return Right(_client.send(request));
    } on HttpException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnexpectedException());
    }
  }
}

// Handlers
ChatCompletionModel _handleChatResponse(Response response) {
  try {
    if (response.statusCode == 200) {
      return ChatCompletionModel.fromJson(response.data);
    }

    throw UnexpectedException();
  } catch (e) {
    throw UnexpectedException();
  }
}

List<String> _handleGetRoadmapResponse(Response response) {
  try {
    if (response.statusCode == 200) {
      ChatCompletionModel chatCompletionModel = ChatCompletionModel.fromJson(
        response.data,
      );
      String content = chatCompletionModel.choices.first.message.content
          .replaceAll('\n', '');
      final int startIndex = content.indexOf('[');
      final int endIndex = content.lastIndexOf(']');
      content = content.substring(startIndex, endIndex + 1);
      final List data = jsonDecode(content);
      return data.map((e) => e['content'].toString()).toList();
    }

    throw UnexpectedException();
  } catch (e) {
    throw UnexpectedException();
  }
}

List<String> _handleGetFieldsOfStudyResponse(Response response) {
  try {
    if (response.statusCode == 200) {
      ChatCompletionModel chatCompletionModel = ChatCompletionModel.fromJson(
        response.data,
      );
      String content = chatCompletionModel.choices.first.message.content
          .replaceAll('\n', '');
      final int startIndex = content.indexOf('[');
      final int endIndex = content.lastIndexOf(']');
      content = content.substring(startIndex, endIndex + 1);
      final List data = jsonDecode(content);
      return data.map((e) => e.toString()).toList();
    }

    throw UnexpectedException();
  } catch (e) {
    throw UnexpectedException();
  }
}

String _handleCreateClassResponse(Response response) {
  try {
    if (response.statusCode == 200) {
      ChatCompletionModel chatCompletionModel =
          ChatCompletionModel.fromJson(response.data);

      String content = chatCompletionModel.choices.first.message.content;

      return content;
    }

    throw UnexpectedException();
  } catch (e) {
    throw UnexpectedException();
  }
}
