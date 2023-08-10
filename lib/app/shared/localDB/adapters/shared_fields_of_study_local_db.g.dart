// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_fields_of_study_local_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SharedFieldsOfStudyLocalDBAdapter
    extends TypeAdapter<SharedFieldsOfStudyLocalDB> {
  @override
  final int typeId = 1;

  @override
  SharedFieldsOfStudyLocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharedFieldsOfStudyLocalDB(
      items: (fields[0] as List).cast<SharedFieldOfStudyItemModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, SharedFieldsOfStudyLocalDB obj) {
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
      other is SharedFieldsOfStudyLocalDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SharedFieldOfStudyItemLocalDBAdapter
    extends TypeAdapter<SharedFieldOfStudyItemLocalDB> {
  @override
  final int typeId = 2;

  @override
  SharedFieldOfStudyItemLocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharedFieldOfStudyItemLocalDB(
      name: fields[0] as String,
      description: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SharedFieldOfStudyItemLocalDB obj) {
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
      other is SharedFieldOfStudyItemLocalDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
