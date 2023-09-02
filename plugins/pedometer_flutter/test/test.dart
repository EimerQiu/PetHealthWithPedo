import 'package:iirjdart/butterworth.dart';

void main() {
  final dataToFilter = List<double>.filled(500, 0.0);
  dataToFilter[10] = 1.0;

  final butterworth = Butterworth();
  butterworth.lowPass(4, 250, 50);

  final filteredData = <double>[];
  for(var v in dataToFilter) {
    filteredData.add(butterworth.filter(v));
  }

  print(filteredData);
}