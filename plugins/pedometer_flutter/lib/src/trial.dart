// ignore_for_file: use_string_in_part_of_directives
/*
 * Copyright 2023 POPULAR HEALTH LLC.
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of pedometer_flutter;

/// [Trial] class that represents a single trial of a pedometer measurement.
class Trial {
  /// Creates a new instance of the [Trial] class.
  ///
  /// @param name The name of the trial.
  /// @param rate The rate of the trial in steps per second.
  /// @param steps The number of steps in the trial.
  Trial({required String name, int? rate, int? steps}) {
    name = name.replaceAll(RegExp(' '), '');

    if (name.isNotEmpty) {
      this.name = name;
    } else {
      throw Exception('Invalid name');
    }

    if (rate != null && rate <= 0) {
      throw Exception('Invalid rate');
    } else {
      this.rate = rate;
    }

    if (steps != null && steps < 0) {
      throw Exception('Invalid steps');
    } else {
      this.steps = steps;
    }
  }

  /// The name of the trial.
  late String name;

  /// The rate of the trial in steps per second.
  int? rate;

  /// The number of steps in the trial.
  int? steps;
}
