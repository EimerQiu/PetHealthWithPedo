// ignore_for_file: use_string_in_part_of_directives
/*
 * Copyright 2023 POPULAR HEALTH LLC.
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of pedometer_flutter;

/// The [Processor] class processes the raw data by applying dot product
/// and filtering the result.
class Processor {
  /// Creates a new instance of the [Processor] class with the given data.
  Processor({required this.data});

  /// A factory method to create an instance of the [Processor] class
  /// and run the dot product and filtering operations on the input data.
  factory Processor.run(List<List<List<double>>> data) => Processor(data: data)
    ..dotProduct()
    ..filter();

  /// The raw data that needs to be processed.
  List<List<List<double>>> data;

  /// Store the result of the dot product operation.
  List<double>? dotProductData;

  /// Store the result of the filtering operation.
  List<double>? filteredData;

  /// Applies the dot product operation on the raw data.
  void dotProduct() {
    dotProductData = data
        .map((e) => e[0][0] * e[1][0] + e[0][1] * e[1][1] + e[0][2] * e[1][2])
        .toList();
  }

  /// Applies the filtering operation on the dot product result.
  void filter() {
    filteredData = Filter.low5Hz(dotProductData!);
    filteredData = Filter.high1Hz(filteredData!);
  }
}
