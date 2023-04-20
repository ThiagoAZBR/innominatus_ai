// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_roadmap.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudyRoadmapAdapter extends TypeAdapter<StudyRoadmap> {
  @override
  final int typeId = 2;

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
