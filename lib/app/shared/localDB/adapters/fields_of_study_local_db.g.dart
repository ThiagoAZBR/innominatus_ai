// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fields_of_study_local_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FieldsOfStudyLocalDBAdapter extends TypeAdapter<FieldsOfStudyLocalDB> {
  @override
  final int typeId = 3;

  @override
  FieldsOfStudyLocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FieldsOfStudyLocalDB(
      items: (fields[0] as List).cast<FieldOfStudyItemModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, FieldsOfStudyLocalDB obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldsOfStudyLocalDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FieldOfStudyItemLocalDBAdapter
    extends TypeAdapter<FieldOfStudyItemLocalDB> {
  @override
  final int typeId = 4;

  @override
  FieldOfStudyItemLocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FieldOfStudyItemLocalDB(
      subjects: (fields[0] as List).cast<SubjectItemModel>(),
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
      other is FieldOfStudyItemLocalDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubjectItemLocalDBAdapter extends TypeAdapter<SubjectItemLocalDB> {
  @override
  final int typeId = 5;

  @override
  SubjectItemLocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectItemLocalDB(
      name: fields[0] as String,
      classes: (fields[1] as List?)?.cast<ClassItemModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, SubjectItemLocalDB obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.classes);
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

class ClassItemLocalDBAdapter extends TypeAdapter<ClassItemLocalDB> {
  @override
  final int typeId = 6;

  @override
  ClassItemLocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassItemLocalDB(
      name: fields[0] as String,
      wasItCompleted: fields[1] as bool,
      content: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ClassItemLocalDB obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.wasItCompleted)
      ..writeByte(2)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassItemLocalDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
