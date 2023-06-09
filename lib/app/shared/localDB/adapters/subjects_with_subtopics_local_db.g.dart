// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subjects_with_subtopics_local_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectsWithSubtopicsLocalDBAdapter
    extends TypeAdapter<SubjectsWithSubtopicsLocalDB> {
  @override
  final int typeId = 1;

  @override
  SubjectsWithSubtopicsLocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectsWithSubtopicsLocalDB(
      subjects: (fields[0] as List).cast<SubjectItemModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, SubjectsWithSubtopicsLocalDB obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.subjects);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectsWithSubtopicsLocalDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubjectItemLocalDBAdapter extends TypeAdapter<SubjectItemLocalDB> {
  @override
  final int typeId = 2;

  @override
  SubjectItemLocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectItemLocalDB(
      subtopics: (fields[0] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SubjectItemLocalDB obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.subtopics);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectItemLocalDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
