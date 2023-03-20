import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/widgets.dart';
import 'package:rx_notifier/rx_notifier.dart';

import 'domain/models/chat_completion.dart';
import 'domain/usecases/create_chat_completion.dart';
import 'modules/home/app_states.dart';
import 'shared/utils/validator_utils.dart';

class AppController {
  // UseCases
  final CreateChatCompletion chatCompletion;
  // Normal Variables
  final String validMessage = "Aplicação autorizada!";
  final TextEditingController messageFieldController = TextEditingController();
  FocusNode messageFieldFocusNode = FocusNode();
  // Reactive Variables
  final chatMessages = RxList<ChatMessage>();
  final userMessages = RxList<String>();
  final artificialIntelligenceMessages = RxList<String>();
  final _isAppAvailable = RxNotifier(false);
  final _errorMessage = RxNotifier<String?>(null);
  final _state = RxNotifier<AppState>(const DefaultState());
  // Functions
  Future<AppState> createChatCompletion(
    CreateChatCompletionParam params,
  ) async {
    final hasError = ValidatorUtils.isValidForRequest(
      params.content,
      userMessages,
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
    userMessages.add(content);
    chatMessages.add(ChatMessage(isUser: true, message: content));
  }

  void saveAIMessages(String content) {
    artificialIntelligenceMessages.add(content);
    chatMessages.add(ChatMessage(isUser: false, message: content));
  }

  void showErrorToUser() {
    chatMessages.add(ChatMessage(
        isUser: false,
        message:
            'Ocorreu um erro ao tentar gerar a sua resposta.\nPor favor, tente novamente!'));
  }

  void cleanData() {
    messageFieldController.clear();
    chatMessages.clear();
    artificialIntelligenceMessages.clear();
    userMessages.clear();
    setTextFieldError(null);
    _state.value = const DefaultState();
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
  void setLoading() => _state.value = const LoadingState();

  AppState setHttpError([Exception? failure]) {
    _state.value = const HttpErrorState();
    return appState;
  }

  AppState setMissingRequisitesError(String message) {
    setTextFieldError(message);
    _state.value = const MissingRequisitesState();
    return appState;
  }

  AppState setDefaultState(ChatCompletionModel chatCompletion) {
    saveAIMessages(chatCompletion.choices.first.message.content.trimLeft());
    _state.value = const DefaultState();
    return appState;
  }

  bool isLoading() => _state.value is LoadingState;
  bool hasError() => _state.value is HttpErrorState;
  AppState get appState => _state.value;

  int takeLength() => artificialIntelligenceMessages.length;

  bool get isAppAvailable => _isAppAvailable.value;
  void setAppToAvailable() => _isAppAvailable.value = true;

  String? get errorMessage => _errorMessage.value;
  void setTextFieldError(String? message) => _errorMessage.value = message;

  AppController(this.chatCompletion);
}

class ChatMessage {
  final bool isUser;
  final String message;

  ChatMessage({
    required this.isUser,
    required this.message,
  });
}
