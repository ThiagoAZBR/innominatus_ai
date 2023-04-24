// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_subject.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
