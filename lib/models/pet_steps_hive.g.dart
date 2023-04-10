// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_steps_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PetStepsHiveAdapter extends TypeAdapter<PetStepsHive> {
  @override
  final int typeId = 0;

  @override
  PetStepsHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PetStepsHive(
      steps: fields[0] as int,
      timestamp: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PetStepsHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.steps)
      ..writeByte(1)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetStepsHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
