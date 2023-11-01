class ClassRemoteDBModel {
  final String name;
  final String content;
  final String audioUrl;

  ClassRemoteDBModel({
    required this.name,
    required this.content,
    required this.audioUrl,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'content': content});
    result.addAll({'audioUrl': audioUrl});

    return result;
  }

  factory ClassRemoteDBModel.fromMap(Map<String, dynamic> map) {
    return ClassRemoteDBModel(
      name: map['name'] ?? '',
      content: map['content'] ?? '',
      audioUrl: map['audioUrl'] ?? '',
    );
  }
}
