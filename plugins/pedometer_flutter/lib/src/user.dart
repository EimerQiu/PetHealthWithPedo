// ignore_for_file: use_string_in_part_of_directives
/*
 * Copyright 2023 POPULAR HEALTH LLC.
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of pedometer_flutter;

/// Represents a [User] profile which contains information about
/// the gender, height, and stride length of the user.
class User {
  /// Creates a new instance of [User] class.
  ///
  /// @param gender The gender of the user.
  /// @param height The height of the user.
  /// @param stride The stride length of the user.
  User({String? gender, double? height, double? stride}) {
    if (gender != null && gender.isNotEmpty) {
      gender = gender.toLowerCase();
    }

    if (gender != null && !_genders.contains(gender)) {
      throw Exception('Invalid gender');
    } else {
      this.gender = gender;
    }

    if (height != null && height <= 0) {
      throw Exception('Invalid height');
    } else {
      this.height = height;
    }

    if (stride != null && stride <= 0) {
      throw Exception('Invalid stride');
    } else {
      this.stride = stride ?? _calculateStride();
    }
  }

  /// The gender of the user.
  String? gender;

  /// The height of the user.
  double? height;

  /// The stride length of the user.
  double? stride;

  /// List of available genders
  final List<String> _genders = ['male', 'female'];

  /// Map of gender to stride length multiplier
  final Map<String, double> _multipliers = {'female': 0.413, 'male': 0.415};

  /// Map of average stride length for each gender
  final Map<String, double> _averages = {'female': 70.0, 'male': 78.0};

  /// Calculates the stride length of the user.
  double _calculateStride() {
    if (gender != null && height != null) {
      return _multipliers[gender]! * height!;
    } else if (height != null) {
      return height! *
          (_multipliers.values.reduce((a, b) => a + b) / _multipliers.length);
    } else if (gender != null) {
      return _averages[gender]!;
    } else {
      return _averages.values.reduce((a, b) => a + b) / _averages.length;
    }
  }
}
