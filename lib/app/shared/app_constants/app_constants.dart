class AppConstants {
  static const String chaosSelfIntroduction =
      'Olá!\n\nEstou aqui para responder suas dúvidas e perguntas sobre os conteúdos!\n\nMe envie suas dúvidas e ficarei feliz em poder ajudar.';
  // Prompts
  static String getRoadmap(String content) =>
      'Crie um Roadmap de estudos sobre $content e escreva em formato de Json, onde será um array de objetos, onde cada objeto terá a apenas a chave "content"';
  static const String getFieldsOfStudy =
      'Escreva em formato de Json, onde terá uma chave "items" e um valor que vai ser um Array de Strings. Dentro do Array, escreve o máximo possível áreas de estudo escolhidas na faculdade e em alta no mercado de trabalho';
  static String createClass(String className) =>
      'Você é uma IA especializada em educação. Me de uma explicação/aula bem detalhada sobre $className.';
  static const String revenueCatApiKey = 'goog_MuwDROSUcNeBQQNOFUYWxlBQgTZ';
  static const String premiumPlan = 'Premium';

  static const String chatAnswersLimit = 'chatAnswersLimit';
  static const String generatedClassesLimit = 'generatedClassesLimit';
}
