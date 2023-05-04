// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subjects_local_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectsLocalDBAdapter extends TypeAdapter<SubjectsLocalDB> {
  @override
  final int typeId = 6;

  @override
  SubjectsLocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectsLocalDB(
      items: (fields[0] as List).cast<SubjectItemModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, SubjectsLocalDB obj) {
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
      other is SubjectsLocalDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubjectItemLocalDBAdapter extends TypeAdapter<SubjectItemLocalDB> {
  @override
  final int typeId = 7;

  @override
  SubjectItemLocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectItemLocalDB(
      subject: fields[0] as String,
      description: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SubjectItemLocalDB obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.subject)
      ..writeByte(1)
      ..write(obj.description);
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
