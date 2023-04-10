// ignore_for_file: use_string_in_part_of_directives
/*
 * Copyright 2023 POPULAR HEALTH LLC.
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of pedometer_flutter;

/// The [Analyzer] class is a class that facilitates analysis of processed data
/// by calculating steps, delta, distance, and time.
class Analyzer {
  /// Creates a new instance of the [Analyzer] class with
  /// the given data, [User] and [Trial].
  Analyzer({required this.data, required this.user, required this.trial});

  /// A factory method to create and return an instance of the [Analyzer]
  /// class after measuring steps, delta, distance and time.
  ///
  /// @param data: processed data that needs to be analyzed.
  /// @param user: holds information about the user.
  /// @param trial: holds information about the trial.
  /// @return: An instance of the [Analyzer] class with
  /// steps, delta, distance, and time
  factory Analyzer.run(List<double> data, User user, Trial trial) =>
      Analyzer(data: data, user: user, trial: trial)
        .._measureSteps()
        .._measureDelta()
        .._measureDistance()
        .._measureTime();

  /// Represents a constant value for threshold used for step counting.
  static const double threshold = 0.04;

  /// Holds the number of steps.
  int? steps;

  /// Holds the delta value.
  int? delta;

  /// Holds the calculated distance.
  double? distance;

  /// Holds the calculated time.
  double? time;

  /// List of processed data
  List<double> data;

  /// Holds information about the [User].
  User user;

  /// Holds information about the [Trial].
  Trial trial;

  /// A method that measures the number of steps from the processed data.
  void _measureSteps() {
    steps = 0;
    var countSteps = true;

    for (var i = 0; i < data.length; i++) {

      if (data[i] >= threshold) {
        steps = steps! + 1;
      }

      // if (data[i] >= threshold && data[i - 1] < threshold) {
      //   if (!countSteps) {
      //     continue;
      //   }

      //   steps = steps! + 1;
      //   countSteps = false;
      // }

      // if (data[i] < 0 && data[i - 1] >= 0) {
      //   countSteps = true;
      // }
    }
  }

  /// A method that measures the delta value.
  void _measureDelta() {
    if (trial.steps != null) {
      delta = steps! - trial.steps!;
    }
  }

  /// A method that measures the distance from the processed data.
  void _measureDistance() {
    distance = user.stride! * steps!;
  }

  /// A method that measures the time from the processed data.
  void _measureTime() {
    if (trial.rate != null) {
      time = data.length / trial.rate!;
    }
  }
}
