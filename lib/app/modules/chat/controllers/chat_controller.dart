import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/widgets.dart';
import 'package:rx_notifier/rx_notifier.dart';

import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/text_constants/app_constants.dart';
import 'package:innominatus_ai/app/modules/chat/controllers/states/chat_states.dart';
import 'package:innominatus_ai/app/shared/miscellaneous/exceptions.dart';

import '../../../domain/models/chat_completion.dart';
import '../../../domain/usecases/chat/create_chat_completion.dart';
import '../../../shared/utils/validator_utils.dart';

class ChatController {
  final AppController appController;
  final CreateChatCompletion chatCompletion;

  final String validMessage = "Aplicação autorizada!";
  final TextEditingController messageFieldController = TextEditingController();
  FocusNode messageFieldFocusNode = FocusNode();

  final _state$ = RxNotifier<ChatState>(const ChatDefaultState());
  final _errorMessage$ = RxNotifier<String?>(null);
  final _isAppAvailable$ = RxNotifier(false);
  final userMessages$ = RxList<String>();
  final artificialIntelligenceMessages$ = RxList<String>([
    AppConstants.chaosSelfIntroduction,
  ]);
  final chatMessages$ = RxList<ChatMessage>([
    ChatMessage(
      isUser: false,
      message: AppConstants.chaosSelfIntroduction,
    ),
  ]);

  ChatController(
    this.appController,
    this.chatCompletion,
  );

  Future<ChatState> createChatCompletion(
    CreateChatCompletionParam params,
  ) async {
    final hasError = ValidatorUtils.isValidForRequest(
      params.content,
      userMessages$,
    );
    if (hasError != null) {
      return setMissingRequisitesError(hasError);
    }
    messageFieldFocusNode.unfocus();
    messageFieldController.clear();
    saveUserMessage(params.content);
    setLoading();
    final response = await chatCompletion(params: params);
    return response.fold(setHttpError, setDefaultState);
  }

  void saveUserMessage(String content) {
    userMessages$.add(content);
    chatMessages$.add(ChatMessage(isUser: true, message: content));
  }

  void saveAIMessages(String content) {
    artificialIntelligenceMessages$.add(content);
    chatMessages$.add(ChatMessage(isUser: false, message: content));
  }

  void showErrorToUser() {
    chatMessages$.add(ChatMessage(
        isUser: false,
        message:
            'Ocorreu um erro ao tentar gerar a sua resposta.\nPor favor, tente novamente!'));
  }

  void cleanData() {
    messageFieldController.clear();
    chatMessages$.clear();
    artificialIntelligenceMessages$.clear();
    userMessages$.clear();
    setTextFieldError(null);
    _state$.value = const ChatDefaultState();
  }

  Future<bool> validateIfAppIsAvailable() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    await remoteConfig.fetchAndActivate();
    final bool availability = remoteConfig.getBool("isAvailable");
    return availability;
  }

  // Getters and Setters
  void setLoading() => _state$.value = const ChatLoadingState();

  ChatState setHttpError([Exception? failure]) {
    if (failure is HomologResponse) {
      saveAIMessages('Ainda está funcionando :D');
      _state$.value = const ChatDefaultState();
      return appState;
    }
    _state$.value = const ChatHttpErrorState();
    return appState;
  }

  ChatState setMissingRequisitesError(String message) {
    setTextFieldError(message);
    _state$.value = const ChatMissingRequisitesState();
    return appState;
  }

  ChatState setDefaultState(ChatCompletionModel chatCompletion) {
    saveAIMessages(chatCompletion.choices.first.message.content.trimLeft());
    _state$.value = const ChatDefaultState();
    return appState;
  }

  bool isLoading() => _state$.value is ChatLoadingState;
  bool hasError() => _state$.value is ChatHttpErrorState;
  ChatState get appState => _state$.value;

  int takeLength() => artificialIntelligenceMessages$.length;

  bool get isAppAvailable => _isAppAvailable$.value;
  void setAppToAvailable() => _isAppAvailable$.value = true;

  String? get errorMessage => _errorMessage$.value;
  void setTextFieldError(String? message) => _errorMessage$.value = message;
}

class ChatMessage {
  final bool isUser;
  final String message;

  ChatMessage({
    required this.isUser,
    required this.message,
  });
}
