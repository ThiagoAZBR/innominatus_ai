// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subjects_with_subtopics_local_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectsWithSubtopicsLocalDBAdapter
    extends TypeAdapter<FieldsOfStudyWithSubjectsLocalDB> {
  @override
  final int typeId = 1;

  @override
  FieldsOfStudyWithSubjectsLocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FieldsOfStudyWithSubjectsLocalDB(
      fieldsOfStudy: (fields[0] as List).cast<FieldOfStudyItemModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, FieldsOfStudyWithSubjectsLocalDB obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.fieldsOfStudy);
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

class SubjectItemLocalDBAdapter extends TypeAdapter<FieldOfStudyItemLocalDB> {
  @override
  final int typeId = 2;

  @override
  FieldOfStudyItemLocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FieldOfStudyItemLocalDB(
      subjects: (fields[0] as List).cast<String>(),
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FieldOfStudyItemLocalDB obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.subjects)
      ..writeByte(1)
      ..write(obj.name);
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
