// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_topic.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubTopicAdapter extends TypeAdapter<SubTopic> {
  @override
  final int typeId = 1;

  @override
  SubTopic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubTopic(
      subjectParent: fields[0] as String,
      classSubjects: (fields[1] as List).cast<String>(),
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
