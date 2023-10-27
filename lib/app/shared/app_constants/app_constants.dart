class AppConstants {
  static const String chaosSelfIntroduction =
      'Olá!\n\nEstou aqui para responder suas dúvidas e perguntas sobre os conteúdos!\n\nMe envie suas dúvidas e ficarei feliz em poder ajudar.';

  // Prompts
  static String getRoadmap(String content, String language) {
    if (language == 'en') {
      return 'You are an AI specialized in education. Create a study roadmap for $content and write it in Json format, which will be an array of objects, where each object will have only the key "content"';
    }
    return 'Você é uma IA especializada em educação. Crie um Roadmap de estudos sobre $content e escreva em formato de Json, onde será um array de objetos, onde cada objeto terá a apenas a chave "content"';
  }

  static String createClass(String className, String language) {
    if (language == 'en') {
      return 'You are an AI specialized in education. Give me a very detailed explanation/lesson about $className.';
    }
    return 'Você é uma IA especializada em educação. Me de uma explicação/aula bem detalhada sobre $className.';
  }

  static const String getFieldsOfStudy =
      'Escreva em formato de Json, onde terá uma chave "items" e um valor que vai ser um Array de Strings. Dentro do Array, escreve o máximo possível áreas de estudo escolhidas na faculdade e em alta no mercado de trabalho';
  static generateFieldsOfStudy(String language) =>
      'Traduza os valores dos parâmetros para $language, mais nada de alteração:\n';

  // RevenueCat
  static const String revenueCatApiKey = 'goog_MuwDROSUcNeBQQNOFUYWxlBQgTZ';
  static const String premiumPlan = 'Premium';

  // RemoteConfig
  static const String chatAnswersLimit = 'chatAnswersLimit';
  static const String generatedClassesLimit = 'generatedClassesLimit';
  static const String remoteVersion = 'remoteVersion';
}
