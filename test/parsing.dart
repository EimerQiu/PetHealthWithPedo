import 'dart:io';

void main() {
  File file = File('D45B8D9572EB_1680142020410_gyroAccCombined_data.txt');
  String fileContent = file.readAsStringSync();
  List<String> lines = fileContent.split('\n');
  lines.removeWhere((element) => element.isEmpty);
  List<Signal> signals = [];

  for (String line in lines) {
    List<String> values = line.split(', ');

    DateTime timestamp = DateTime.parse(values[0]);

    Acc acc = Acc(
      x: double.parse(values[1]),
      y: double.parse(values[2]),
      z: double.parse(values[3]),
      magnitude: double.parse(values[4]),
    );
    Gyro gyro = Gyro(
      x: double.parse(values[5]),
      y: double.parse(values[6]),
      z: double.parse(values[7]),
    );
    Signal signal = Signal(
      timestamp: timestamp,
      acc: acc,
      gyro: gyro,
    );

    print(signal.acc);
    print(signal.gyro);
    signals.add(signal);
  }

  // Do whatever you need with the parsed data.
}

class Signal {
  DateTime timestamp;
  Acc acc;
  Gyro gyro;

  Signal({
    required this.timestamp,
    required this.acc,
    required this.gyro,
  });
}

class Acc {
  double x;
  double y;
  double z;
  double magnitude;

  Acc({
    required this.x,
    required this.y,
    required this.z,
    required this.magnitude,
  });
}

class Gyro {
  double x;
  double y;
  double z;

  Gyro({
    required this.x,
    required this.y,
    required this.z,
  });
}
