// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subjects_local_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SharedSubjectsLocalDBAdapter extends TypeAdapter<SharedSubjectsLocalDB> {
  @override
  final int typeId = 6;

  @override
  SharedSubjectsLocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharedSubjectsLocalDB(
      items: (fields[0] as List).cast<SharedFieldOfStudyModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, SharedSubjectsLocalDB obj) {
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
      other is SharedSubjectsLocalDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SharedSubjectItemLocalDBAdapter
    extends TypeAdapter<SharedSubjectItemLocalDB> {
  @override
  final int typeId = 7;

  @override
  SharedSubjectItemLocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharedSubjectItemLocalDB(
      name: fields[0] as String,
      description: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SharedSubjectItemLocalDB obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharedSubjectItemLocalDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
