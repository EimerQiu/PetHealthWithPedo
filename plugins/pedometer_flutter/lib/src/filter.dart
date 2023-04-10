// ignore_for_file: use_string_in_part_of_directives
/*
 * Copyright 2023 POPULAR HEALTH LLC.
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of pedometer_flutter;

/// The [Filter] class provides functionality for filtering a given data.
class Filter {
  /// Coefficients for the low-pass filter with a cutoff frequency of 0Hz.
  static final Map<String, List<double>> _coefficientsLow0Hz = {
    'alpha': [1, -1.979133761292768, 0.979521463540373],
    'beta': [0.000086384997973502, 0.000172769995947004, 0.000086384997973502]
  };

  /// Coefficients for the low-pass filter with a cutoff frequency of 5Hz.
  static final Map<String, List<double>> _coefficientsLow5Hz = {
    'alpha': [1, -1.80898117793047, 0.827224480562408],
    'beta': [0.095465967120306, -0.172688631608676, 0.095465967120306]
  };

  /// Coefficients for the high-pass filter with a cutoff frequency of 1Hz.
  static final Map<String, List<double>> _coefficientsHigh1Hz = {
    'alpha': [1, -1.905384612118461, 0.910092542787947],
    'beta': [0.953986986993339, -1.907503180919730, 0.953986986993339]
  };

  /// Applies a low-pass filter with 0 Hz cutoff frequency to the input `data`
  ///
  /// @param data the input data to filter
  /// @return a list of filtered data points
  static List<double> low0Hz(List<double> data) =>
      filter(data, _coefficientsLow0Hz);

  /// Applies a low-pass filter with 5 Hz cutoff frequency to the input `data`
  ///
  /// @param data the input data to filter
  /// @return a list of filtered data points
  static List<double> low5Hz(List<double> data) =>
      filter(data, _coefficientsLow5Hz);

  /// Applies a high-pass filter with 1 Hz cutoff frequency to the input `data`
  ///
  /// @param data the input data to filter
  /// @return a list of filtered data points
  static List<double> high1Hz(List<double> data) =>
      filter(data, _coefficientsHigh1Hz);

  /// Filters the input `data` using the specified `coefficients`
  ///
  /// @param data the input data to filter
  /// @param coefficients the filter coefficients to use
  /// @return a list of filtered data points
  static List<double> filter(
    List<double> data,
    Map<String, List<double>> coefficients,
  ) {
    final filteredData = <double>[0, 0];

    for (var i = 2; i < data.length; i++) {
      filteredData.add(
        coefficients['alpha']![0] *
            (data[i] * coefficients['beta']![0] +
                data[i - 1] * coefficients['beta']![1] +
                data[i - 2] * coefficients['beta']![2] -
                filteredData[i - 1] * coefficients['alpha']![1] -
                filteredData[i - 2] * coefficients['alpha']![2]),
      );
    }
    return filteredData;
  }
}
