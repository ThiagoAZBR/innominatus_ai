class AppConstants {
  static const String chaosSelfIntroduction =
      'Olá, sou a Chaos!\n\nSuas dúvidas de estudos e assuntos correlatos podem ser respondidas por mim. \n\nMe envie suas dúvidas e ficarei feliz em poder ajudar!';
  // Prompts
  static String getClassContent(String content) =>
      'Crie uma aula bem detalhada sobre $content. Coloque os subtitulos entre <>';
  static String getRoadmap(String content) =>
      'Crie um Roadmap de estudos sobre $content e escreva em formato de Json, onde será um array de objetos, onde cada objeto terá a apenas a chave "content"';
  static const String getFieldsOfStudy =
      'Escreva em formato de Json, onde terá uma chave "items" e um valor que vai ser um Array de Strings. Dentro do Array, escreve o máximo possível áreas de estudo escolhidas na faculdade e em alta no mercado de trabalho';
}
