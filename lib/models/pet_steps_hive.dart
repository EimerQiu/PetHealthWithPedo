// models/pet_steps_hive.dart
import 'package:hive/hive.dart';

part 'pet_steps_hive.g.dart';

@HiveType(typeId: 0)
class PetStepsHive extends HiveObject {
  @HiveField(0)
  final int steps;

  @HiveField(1)
  final int timestamp;

  @HiveField(2)
  final String rawData;

  // Set the default value for rawData to an empty string
  PetStepsHive({required this.steps, required this.timestamp, this.rawData = ''});
}
