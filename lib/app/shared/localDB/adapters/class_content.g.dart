// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_content.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassContentAdapter extends TypeAdapter<ClassContent> {
  @override
  final int typeId = 4;

  @override
  ClassContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassContent(
      script: fields[0] as String,
      questions: (fields[1] as List?)?.cast<Question>(),
    );
  }

  @override
  void write(BinaryWriter writer, ClassContent obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.script)
      ..writeByte(1)
      ..write(obj.questions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
