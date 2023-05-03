class SubjectsModel {
  final List<String> items;

  SubjectsModel({
    required this.items,
  });

  factory SubjectsModel.fromMap(Map<String, dynamic> map) {
    return SubjectsModel(
      items: List<String>.from(map['items']),
    );
  }
}
