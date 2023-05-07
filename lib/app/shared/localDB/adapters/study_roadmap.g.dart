// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_roadmap.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudyRoadmapAdapter extends TypeAdapter<StudyRoadmap> {
  @override
  final int typeId = 1;

  @override
  StudyRoadmap read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudyRoadmap(
      subTopic: (fields[0] as List).cast<SubTopic>(),
    );
  }

  @override
  void write(BinaryWriter writer, StudyRoadmap obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.subTopic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyRoadmapAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubTopicAdapter extends TypeAdapter<SubTopic> {
  @override
  final int typeId = 2;

  @override
  SubTopic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubTopic(
      subjectParent: fields[0] as String,
      classSubjects: (fields[1] as List).cast<ClassSubject>(),
    );
  }

  @override
  void write(BinaryWriter writer, SubTopic obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.subjectParent)
      ..writeByte(1)
      ..write(obj.classSubjects);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubTopicAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ClassSubjectAdapter extends TypeAdapter<ClassSubject> {
  @override
  final int typeId = 3;

  @override
  ClassSubject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassSubject(
      hasConclude: fields[0] as bool,
      classTitle: fields[1] as String,
      classContent: fields[2] as ClassContent,
    );
  }

  @override
  void write(BinaryWriter writer, ClassSubject obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.hasConclude)
      ..writeByte(1)
      ..write(obj.classTitle)
      ..writeByte(2)
      ..write(obj.classContent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassSubjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ClassContentAdapter extends TypeAdapter<ClassContent> {
  @override
  final int typeId = 4;

  @override
  ClassContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassContent(
      script: fields[0] as String,
      questions: (fields[1] as List?)?.cast<Question>(),
    );
  }

  @override
  void write(BinaryWriter writer, ClassContent obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.script)
      ..writeByte(1)
      ..write(obj.questions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestionAdapter extends TypeAdapter<Question> {
  @override
  final int typeId = 5;

  @override
  Question read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Question(
      question: fields[0] as String,
      answer: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Question obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.question)
      ..writeByte(1)
      ..write(obj.answer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
