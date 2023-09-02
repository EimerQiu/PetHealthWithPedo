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
      rawData: fields[2] as String, // Add this line to read the rawData field
    );
  }

  @override
  void write(BinaryWriter writer, PetStepsHive obj) {
    writer
      ..writeByte(3) // Update the number of fields from 2 to 3
      ..writeByte(0)
      ..write(obj.steps)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2) // Add this line to write the rawData field index
      ..write(obj.rawData); // Add this line to write the rawData field value
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
