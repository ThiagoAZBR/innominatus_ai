// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'non_premium_user_local_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NonPremiumUserLocalDBAdapter extends TypeAdapter<NonPremiumUserLocalDB> {
  @override
  final int typeId = 7;

  @override
  NonPremiumUserLocalDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NonPremiumUserLocalDB(
      hasReachedLimit: fields[0] as bool,
      generatedClasses: fields[1] as int,
      chatAnswers: fields[2] as int,
      actualDay: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, NonPremiumUserLocalDB obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.hasReachedLimit)
      ..writeByte(1)
      ..write(obj.generatedClasses)
      ..writeByte(2)
      ..write(obj.chatAnswers)
      ..writeByte(3)
      ..write(obj.actualDay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NonPremiumUserLocalDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
