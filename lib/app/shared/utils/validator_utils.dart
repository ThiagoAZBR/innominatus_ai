import 'package:innominatus_ai/app/shared/app_constants/app_constants.dart';

class ValidatorUtils {
  static String? isValidForRequest(String content, List<String>? list) {
    if (isEmpty(content)) {
      return 'O campo de texto está vazio.';
    }
    if (!hasAppropriatedLength(content)) {
      return 'A mensagem precisa ter mais do que 3 caracteres.';
    }
    if (equalToPreviousAsk(content, list ?? [])) {
      return 'Essa mensagem já foi enviada anteriormente.';
    }

    return null;
  }

  static bool isEmpty(String content) {
    final result = content.trim().isEmpty;
    return result;
  }

  static bool hasAppropriatedLength(String content) {
    final result = content.trim().length > 3;
    return result;
  }

  static bool equalToPreviousAsk(String content, List<String> list) {
    final result = list.any((element) => element.contains(content));
    return result;
  }

  static bool hasSupportedLanguage(String language) {
    if (language == LanguageConstants.portuguese) {
      return true;
    } else if (language == LanguageConstants.english) {
      return true;
    } else if (language == LanguageConstants.french) {
      return true;
    } else if (language == LanguageConstants.spanish) {
      return true;
    }
    return false;
  }
}
