import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'dart:math' as math;

List<Tuple2<double, double>> parseData(String dataStr) {
  int startIndex = dataStr.indexOf(']') + 1;
  List<String> points = dataStr.substring(startIndex).split(';');
  List<Tuple2<double, double>> data = points
      .where((point) => point.isNotEmpty)
      .map((point) => Tuple2<double, double>(
            double.parse(point.split(',')[0]),
            double.parse(point.split(',')[1]),
          ))
      .toList();
  return data;
}

List<double> calculateVariance(List<Tuple2<double, double>> data) {
  int n = data.length;
  Tuple2<double, double> mean = Tuple2(
    data.map((point) => point.item1).reduce((a, b) => a + b) / n,
    data.map((point) => point.item2).reduce((a, b) => a + b) / n,
  );

  List<double> variances = [
    data
            .map((point) => math.pow(point.item1 - mean.item1, 2))
            .reduce((a, b) => a + b) /
        n,
    data
            .map((point) => math.pow(point.item2 - mean.item2, 2))
            .reduce((a, b) => a + b) /
        n,
  ];
  return variances;
}

List<double> lowPassFilter(List<double> data, double alpha) {
  List<double> filteredData =
      List<double>.filled(data.length, 0, growable: false);
  filteredData[0] = data[0];

  for (int i = 1; i < data.length; i++) {
    filteredData[i] = alpha * data[i] + (1 - alpha) * filteredData[i - 1];
  }

  return filteredData;
}

List<double> removeGravity(List<double> data, double alpha) {
  List<double> gravity = lowPassFilter(data, alpha);
  List<double> gravityRemovedData = List<double>.generate(
      data.length, (index) => data[index] - gravity[index]);
  return gravityRemovedData;
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

int countStepsMain(
    String dataStr,
    double stdDevMultiplierAxes,
    double stdDevMultiplierMagnitude,
    double minInterval,
    int samplesPerSecond,
    double minDifference,
    double smallWaveThreshold) {
  List<Tuple2<double, double>> data = parseData(dataStr);

  List<double> variances = calculateVariance(data);
  int highestVarianceIndex = indexOfMax(variances);

  List<double> highestVarianceAxisData =
      data.map((point) => point.item1).toList();

  double alpha = 0.8;
  List<double> highestVarianceAxisDataNoGravity =
      removeGravity(highestVarianceAxisData, alpha);

  double axisMean = mean(highestVarianceAxisDataNoGravity);
  double axisStd = standardDeviation(highestVarianceAxisDataNoGravity);
  double threshold = axisMean + stdDevMultiplierAxes * axisStd;
  int stepsAxes = countSteps(highestVarianceAxisDataNoGravity, threshold,
      minInterval, samplesPerSecond);

  List<double> magnitude = data
      .map((point) =>
          math.sqrt(math.pow(point.item1, 2) + math.pow(point.item2, 2)))
      .toList();
  List<double> magnitudeNoGravity = removeGravity(magnitude, alpha);

  double magnitudeMean = mean(magnitudeNoGravity);
  debugPrint("Average magnitude($magnitudeMean) ");
  if (magnitudeMean < smallWaveThreshold) {
    return 0;
  }

  double magnitudeStd = standardDeviation(magnitudeNoGravity);
  threshold = magnitudeMean + stdDevMultiplierMagnitude * magnitudeStd;

  int stepsMagnitude =
      countSteps(magnitudeNoGravity, threshold, minInterval, samplesPerSecond);

  String axis = ['X', 'Y', 'Z'][highestVarianceIndex];
  debugPrint("min_interval: $minInterval, min_difference: $minDifference");
  debugPrint(
      "Number of steps using axis $axis (standard deviations:$stdDevMultiplierAxes): $stepsAxes");
  debugPrint(
      "Number of steps using magnitude (standard deviations:$stdDevMultiplierMagnitude): $stepsMagnitude");

  if (stepsAxes < stepsMagnitude * minDifference ||
      stepsMagnitude < stepsAxes * minDifference) {
    return stepsAxes;
  } else {
    return stepsMagnitude;
  }
}

double mean(List<double> list) {
  return list.reduce((a, b) => a + b) / list.length;
}

double standardDeviation(List<double> list) {
  double avg = mean(list);
  double sum = list
      .map((item) => math.pow(item - avg, 2))
      .reduce((a, b) => a + b)
      .toDouble();
  return math.sqrt(sum / list.length);
}

int indexOfMax(List<double> list) {
  int maxIndex = 0;
  double maxValue = double.negativeInfinity;
  for (int i = 0; i < list.length; i++) {
    if (list[i] > maxValue) {
      maxValue = list[i];
      maxIndex = i;
    }
  }
  return maxIndex;
}
