class ChatCompletionModel {
  final String? id;
  final String? object;
  final int? created;
  final String? model;
  final Usage? usage;
  final List<Choice> choices;

  ChatCompletionModel({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.usage,
    required this.choices,
  });

  factory ChatCompletionModel.fromJson(Map<String, dynamic> json) {
    return ChatCompletionModel(
      id: json['id'],
      object: json['object'],
      created: json['created'],
      model: json['model'],
      usage: Usage.fromJson(json['usage']),
      choices: List<Choice>.from(
        json['choices'].map((choice) => Choice.fromJson(choice)),
      ),
    );
  }
}

class Usage {
  final int? promptTokens;
  final int? completionTokens;
  final int? totalTokens;

  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      promptTokens: json['prompt_tokens'],
      completionTokens: json['completion_tokens'],
      totalTokens: json['total_tokens'],
    );
  }
}

class Choice {
  final Message message;
  final String? finishReason;
  final int index;

  Choice({
    required this.message,
    required this.finishReason,
    required this.index,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      message: Message.fromJson(json['message']),
      finishReason: json['finish_reason'],
      index: json['index'],
    );
  }
}

class Message {
  final String role;
  final String content;

  Message({
    required this.role,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'],
      content: json['content'],
    );
  }
}
