class SubjectsModel {
  final List<String> items;
  final Map<String, List<String>> subtopics;

  SubjectsModel({
    required this.items,
    required this.subtopics,
  });

  factory SubjectsModel.fromMap(Map<String, dynamic> map) {
    return SubjectsModel(
      items: List<String>.from(map['items']),
      subtopics: Map<String, List<String>>.from(map['subtopics']),
    );
  }
}
