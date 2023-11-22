class AppConstants {
  static String chaosSelfIntroduction(String language) {
    if (language == LanguageConstants.portuguese) {
      return 'Olá!\n\nEstou aqui para responder suas dúvidas e perguntas sobre os conteúdos!\n\nMe envie suas dúvidas e ficarei feliz em poder ajudar.';
    } else if (language == LanguageConstants.french) {
      return "Bonjour !\n\nJe suis là pour répondre à vos questions et interrogations sur les contenus !\n\nEnvoyez-moi vos questions et je serai ravi(e) de pouvoir vous aider.";
    } else if (language == LanguageConstants.spanish) {
      return "¡Hola!\n\nEstoy aquí para responder a tus dudas y preguntas sobre los contenidos.\n\nEnvíame tus preguntas y estaré encantado(a) de poder ayudarte.";
    }
    return "Hello!\n\nI'm here to answer your doubts and questions about the content!\n\nSend me your questions, and I'll be happy to help.";
  }

  // Prompts
  static String getRoadmap(String content, String language) {
    if (language == LanguageConstants.portuguese) {
      return 'Você é uma IA especializada em educação. Crie um Roadmap de estudos detalhado sobre $content (sem tipo "Módulo", "1." ou "1.1") e escreva em formato de Json, onde será um array de objetos, onde cada objeto terá a apenas a chave "content"';
    } else if (language == LanguageConstants.french) {
      return "Vous êtes une IA spécialisée en éducation. Créez une feuille de route d'études détaillée sur $content (sans type 'Module', '1.' ou '1.1') et écrivez-la au format JSON. Il s'agira d'un tableau d'objets, où chaque objet aura seulement la clé 'content'.";
    } else if (language == LanguageConstants.spanish) {
      return "Eres una IA especializada en educación. Crea una hoja de ruta detallada de estudios sobre $content (sin el tipo 'Módulo', '1.' o '1.1') y escríbelo en formato JSON. Será un array de objetos, donde cada objeto tendrá solamente la clave 'content'.";
    }
    return 'You are an AI specialized in education. Create a detailed learning roadmap for $content (without like "Module", "1." or "1.1") and write it in Json format, which will be an array of objects, where each object will have only the key "content"';
  }

  static String createClass(String className, String language) {
    if (language == LanguageConstants.portuguese) {
      return 'Você é uma IA especializada em educação. Me de uma explicação/aula bem detalhada sobre $className.';
    } else if (language == LanguageConstants.french) {
      return "Vous êtes une IA spécialisée en éducation. Donnez-moi une explication/cours très détaillé(e) sur $className.";
    } else if (language == LanguageConstants.spanish) {
      return "Eres una IA especializada en educación. Dame una explicación/clase muy detallada sobre $className.";
    }
    return 'You are an AI specialized in education. Give me a very detailed explanation about $className.';
  }

  static const String getFieldsOfStudy =
      'Escreva em formato de Json, onde terá uma chave "items" e um valor que vai ser um Array de Strings. Dentro do Array, escreve o máximo possível áreas de estudo escolhidas na faculdade e em alta no mercado de trabalho';
  static generateFieldsOfStudy(String language, String map) =>
      'Traduza os valores dos parâmetros para $language, e devolva da mesma forma em json, mais nada de alteração:\n $map';

  // RevenueCat
  static const String revenueCatApiKey = 'goog_MuwDROSUcNeBQQNOFUYWxlBQgTZ';
  static const String premiumPlan = 'Premium';

  // RemoteConfig
  static const String chatAnswersLimit = 'chatAnswersLimit';
  static const String generatedClassesLimit = 'generatedClassesLimit';
  static const String remoteVersion = 'remoteVersion';

  // Firebase Analytics
  static const String hasReachedChatLimitAnalytics = 'hasReachedLimitAnalytics';
  static const String hasReachedClassLimitAnalytics =
      'hasReachedLimitAnalytics';
}

class LanguageConstants {
  static const String portuguese = 'pt';
  static const String english = 'en';
  static const String french = 'fr';
  static const String spanish = 'es';
}
