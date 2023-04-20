import 'dart:math';
import 'package:tuple/tuple.dart';

int trueStep(String dataStr) {
  if (dataStr[0] == '[') {
    int startIndex = dataStr.indexOf('[') + 1;
    int endIndex = dataStr.indexOf(']');
    int trueStepCount = int.parse(dataStr.substring(startIndex, endIndex));
    return trueStepCount;
  } else {
    return 999;
  }
}

List<Tuple3<double, double, double>> parseData(String dataStr) {
  List<String> points;
  if (dataStr[0] == '[') {
    int startIndex = dataStr.indexOf(']') + 1;
    points = dataStr.substring(startIndex).split(';');
  } else {
    points = dataStr.split(';');
  }
  List<Tuple3<double, double, double>> data = points
      .where((point) => point.isNotEmpty)
      .map((point) => Tuple3<double, double, double>.fromList(
          point.split(',').map((value) => double.parse(value)).toList()))
      .toList();
  return data;
}

List<double> calculateVariance(List<Tuple3<double, double, double>> data) {
  int length = data.length;
  double meanX = data.fold<double>(
          0, (previousValue, element) => previousValue + element.item1) /
      length;
  double meanY = data.fold<double>(
          0, (previousValue, element) => previousValue + element.item2) /
      length;
  double meanZ = data.fold<double>(
          0, (previousValue, element) => previousValue + element.item3) /
      length;

  double varX = data.fold<double>(
          0,
          (previousValue, element) =>
              previousValue + pow(element.item1 - meanX, 2)) /
      length;
  double varY = data.fold<double>(
          0,
          (previousValue, element) =>
              previousValue + pow(element.item2 - meanY, 2)) /
      length;
  double varZ = data.fold<double>(
          0,
          (previousValue, element) =>
              previousValue + pow(element.item3 - meanZ, 2)) /
      length;

  return [varX, varY, varZ];
}

int countSteps(List<double> data, double threshold, double minInterval,
    int samplesPerSecond) {
  int steps = 0;
  double prevSample = data[0];
  int lastStepIndex = 0;
  int consecutiveTooClose = 0;

  for (int index = 1; index < data.length; index++) {
    double sample = data[index];
    if (prevSample <= threshold && sample > threshold) {
      if (index >= lastStepIndex + minInterval * samplesPerSecond) {
        steps += 1 + consecutiveTooClose;
        consecutiveTooClose = 0;
        lastStepIndex = index;
      } else {
        consecutiveTooClose = consecutiveTooClose == 0 ? 1 : 0;
      }
    }
    prevSample = sample;
  }

  return steps;
}

List<Tuple3<double, double, double>> lowPassFilter(
    List<Tuple3<double, double, double>> data, double alpha) {
  List<Tuple3<double, double, double>> filteredData = List.generate(
      data.length, (index) => Tuple3<double, double, double>(0, 0, 0));

  filteredData[0] = data[0];
  for (int i = 1; i < data.length; i++) {
    filteredData[i] = Tuple3<double, double, double>(
      alpha * data[i].item1 + (1 - alpha) * filteredData[i - 1].item1,
      alpha * data[i].item2 + (1 - alpha) * filteredData[i - 1].item2,
      alpha * data[i].item3 + (1 - alpha) * filteredData[i - 1].item3,
    );
  }

  return filteredData;
}

List<Tuple3<double, double, double>> removeGravity(
    List<Tuple3<double, double, double>> data, double alpha) {
  List<Tuple3<double, double, double>> gravity = lowPassFilter(data, alpha);
  List<Tuple3<double, double, double>> gravityRemovedData = List.generate(
      data.length,
      (index) => Tuple3<double, double, double>(
            data[index].item1 - gravity[index].item1,
            data[index].item2 - gravity[index].item2,
            data[index].item3 - gravity[index].item3,
          ));
  return gravityRemovedData;
}

int countStepsMain(
  String dataStr, {
  double stdDevMultiplierAxes = 0.6,
  double stdDevMultiplierMagnitude = 0.7,
  double minInterval = 0.4,
  int samplesPerSecond = 25,
  double minDifference = 0.5,
  double smallWaveThreshold = 0.01,
}) {

  var data = parseData(dataStr);

  //filter out gravity  去除重力
  double alpha = 0.8;
  var dataNoGravity = removeGravity(data, alpha);

  //calculate variance 计算方差
  var variances = calculateVariance(dataNoGravity);

  //axis with highest variance
  int highestVarianceIndex =
      variances.indexWhere((variance) => variance == variances.reduce(max));

  // calculate threshold
  double axisMean = _mean(dataNoGravity.map((row) => row.toList()[highestVarianceIndex] as double).toList());
  double axisStd = _stdDev(dataNoGravity.map((row) => row.toList()[highestVarianceIndex] as double).toList());
  double threshold = axisMean + stdDevMultiplierAxes * axisStd;

  int stepsAxes = countSteps(dataNoGravity.map((row) => row.toList()[highestVarianceIndex] as double).toList(),
      threshold, minInterval, samplesPerSecond);
  print(stepsAxes);

var magnitude = dataNoGravity
    .map((row) {
      List<double> rowList = List<double>.from(row.toList().map((value) => value as double));
      double sumOfSquares = rowList.fold(0.0, (sum, value) => sum + value * value);
      double magnitudeValue = sumOfSquares == 0 ? 0.0 : sqrt(sumOfSquares);
      return magnitudeValue;
    })
    .toList();

  double magnitudeMean = _mean(magnitude);
  print(
        'Average magnitude($magnitudeMean)');
  if (magnitudeMean < smallWaveThreshold) {
    print(
        'Average magnitude($magnitudeMean) is very small. Skipping step counting.');
    return 0;
  }

  double magnitudeStd = _stdDev(magnitude);
  threshold = magnitudeMean + stdDevMultiplierMagnitude * magnitudeStd;

  int stepsMagnitude =
      countSteps(magnitude, threshold, minInterval, samplesPerSecond);

  String axis = ['X', 'Y', 'Z'][highestVarianceIndex];
  print('min_interval: $minInterval, min_difference: $minDifference');
  print(
      'Number of steps using axis $axis (standard deviations:$stdDevMultiplierAxes): $stepsAxes');
  print(
      'Number of steps using magnitude (standard deviations:$stdDevMultiplierMagnitude): $stepsMagnitude');

  if (stepsAxes < stepsMagnitude * minDifference ||
      stepsMagnitude < stepsAxes * minDifference) {
    return stepsAxes;
  } else {
    return stepsMagnitude;
  }
}

// Helper functions for calculating mean and standard deviation.
double _mean(Iterable<double> values) {
  double sum = 0;
  int count = 0;
  for (double value in values) {
    sum += value;
    count++;
  }
  return sum / count;
}

double _stdDev(Iterable<double> values) {
  double meanVal = _mean(values);
  double sumSquaredDiffs =
      values.fold(0, (sum, value) => sum + pow(value - meanVal, 2));
  return sqrt(sumSquaredDiffs / values.length);
}
