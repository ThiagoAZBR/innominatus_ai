// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_plan_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudyPlanLocalDBAdapter extends TypeAdapter<StudyPlanLocalDB> {
  @override
  final int typeId = 3;

  @override
  StudyPlanLocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudyPlanLocalDB(
      studyPlan: fields[0] as SharedFieldsOfStudyModel,
    );
  }

  @override
  void write(BinaryWriter writer, StudyPlanLocalDB obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.studyPlan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyPlanLocalDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
