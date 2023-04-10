// ignore_for_file: use_string_in_part_of_directives
/*
 * Copyright 2023 POPULAR HEALTH LLC.
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of pedometer_flutter;

/// The [Parser] class is used for parsing string data into
/// a list of lists of lists of doubles.
class Parser {
  /// Creates a new instance of the [Parser] class with the given data.
  Parser({required this.data});

  /// A factory method to create a new instance of the [Parser] class and
  /// parses the given data.
  ///
  /// @param data The string data to be parsed.
  /// @return The new instance of the [Parser] class with the parsed data.
  factory Parser.run(String data) => Parser(data: data)..parse();

  /// The string data to be parsed.
  String data;

  /// The parsed data as a list of lists of lists of doubles.
  List<List<List<double>>>? parsedData;

  /// Parses the string data into a list of lists of lists of doubles.
  void parse() {
    /// Extract numerical data into the format:
    /// Type 1: [ [ [x1t, y1t, z1t] ], ..., [ [xnt, ynt, znt] ] ]
    /// Or Type 2:
    /// [ [ [x1u, y1u, z1u], [x1g, y1g, z1g] ], ...,
    ///   [ [xnu, ynu, znu], [xng, yng, zng] ] ]
    try {
      parsedData = data
          .split(';')
          .map((x) => x.split('|').where((element) => element.isNotEmpty))
          .map(
            (y) => y
                .map(
                  (z) =>
                      z.split(',').map((e) => double.tryParse(e) ?? 0).toList(),
                )
                .toList(),
          )
          .toList()
          .where((element) => element.isNotEmpty)
          .toList();
    } catch (e) {
      throw Exception('Bad Input. Ensure data is properly formatted.');
    }

    /// Distinct List of Lists like [[3], [3], [3]] to [[3]]
    List<List<int>> delist(List<List<int>> original) {
      final delisted = <List<int>>[original[0]];

      for (var i = 1; i < original.length; i++) {
        final equal =
            const DeepCollectionEquality().equals(original[i], original[i - 1]);

        if (!equal) {
          delisted.add(original[i]);
        }
      }

      return delisted;
    }

    // Ensure data is properly formatted
    if (parsedData == null ||
        parsedData!.isEmpty ||
        !const DeepCollectionEquality().equals(
          delist(
            parsedData!
                .map((e) => e.map((e) => e.length).toSet().toList())
                .toList(),
          ),
          [
            [3]
          ],
        )) {
      throw Exception('Bad Input. Ensure data is properly formatted.');
    }

    /// Only need to run for Type 1:
    ///[ [ [x1t, y1t, z1t] ], ..., [ [xnt, ynt, znt] ] ]
    if (parsedData!.first.length == 1) {
      /// A list to hold the filtered acceleration data
      var filteredAcceleration = <List<List<double>>>[];

      /// Flatten data from
      /// [[[0.123, -0.123, 5.0]], [[0.456, -0.789, 0.111]], [[-0.212, 0.001, 1.0]]]
      /// to
      /// [[0.123, -0.123, 5.0], [0.456, -0.789, 0.111], [-0.212, 0.001, 1.0]]
      final flattened =
          parsedData!.map((x) => List<double>.from(x.flatten)).toList();

      /// Transpose data from
      /// [[0.123, -0.123, 5.0], [0.456, -0.789, 0.111], [-0.212, 0.001, 1.0]]
      /// to
      /// [[0.123, -0.123, 5.0], [0.456, -0.789, 0.111], [-0.212, 0.001, 1.0]]
      final transposed =
          // ignore: unnecessary_lambdas
          flattened.transpose.map((e) => List<double>.from(e)).toList();

      log('---------------------------------------');

      var timeStamp = DateTime.now().millisecondsSinceEpoch;

      /// Filter out gravity
      filteredAcceleration = transposed.map((totalAcceleration) {
        final gravity = Filter.low0Hz(totalAcceleration);

        /// Zips two lists into a list of lists, where each sublist contains
        /// one element from each of the input lists.
        final userAcceleration = List.generate(
          totalAcceleration.length,
          (i) => totalAcceleration[i] - gravity[i],
        );

        log('${timeStamp} CALC: ${userAcceleration}');
        return [userAcceleration, gravity];
      }).toList();

      /// Transforms a list of filtered acceleration values into a
      /// nested list of X and Y values.
      parsedData = parsedData!
          .asMap()
          .map(
            (i, elem) => MapEntry(i, [
              List<double>.from(
                filteredAcceleration
                    .map((e) => e.first)
                    .map((e) => e[i])
                    .toList(),
              ),
              List<double>.from(
                filteredAcceleration
                    .map((e) => e.last)
                    .map((e) => e[i])
                    .toList(),
              )
            ]),
          )
          .values
          .toList();
    }
  }
}
