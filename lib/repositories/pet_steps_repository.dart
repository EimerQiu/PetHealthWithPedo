import '../models/pet_steps_hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PetStepsRepository {
  static Box<PetStepsHive>? _box;

  Future<void> initHive() async {
    if (_box == null) {
      await Hive.initFlutter();
      Hive.registerAdapter(PetStepsHiveAdapter());
      _box = await Hive.openBox<PetStepsHive>('dogstepsbox');
    }
  }

  Future<List<PetStepsHive>> readStepsRecords() async {
    await initHive(); // Make sure Hive is initialized before accessing the box
    return _box!.values.toList();
  }

  Future<void> saveRecord(int steps, int timestamp,
      [String rawData = '']) async {
    await initHive(); // Make sure Hive is initialized before accessing the box
    await _box!.add(
        PetStepsHive(steps: steps, timestamp: timestamp, rawData: rawData));
  }

  Future<void> close() async {
    await _box?.close();
    _box = null;
  }
}
