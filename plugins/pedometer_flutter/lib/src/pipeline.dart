// ignore_for_file: use_string_in_part_of_directives
/*
 * Copyright 2023 POPULAR HEALTH LLC.
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of pedometer_flutter;

/// The [Pipeline] class is a class that facilitates processing data by
/// combining multiple steps into a single pipeline. It combines the
/// functionality of the [Parser], [Processor], and [Analyzer] classes to
/// process a given input `data` string, with a [User] and a [Trial] object.
class Pipeline {
  /// Creates a new instance of the [Pipeline] class with the given data.
  Pipeline({required this.data, required this.user, required this.trial});

  /// A factory method to create and return a instance of the [Pipeline] object
  /// that runs the pipeline for processing the input data.
  ///
  /// @param data: The input data that needs to be processed.
  /// @param user: Provides information about the [User].
  /// @param trial: Provides information about the [Trial].
  /// @return: An instance of the [Pipeline] class.
  factory Pipeline.run(String data, User user, Trial trial) =>
      Pipeline(data: data, user: user, trial: trial)..feed();

  /// Represent the input data that needs to be processed.
  String data;

  /// [User] object that provides information about the user
  User user;

  /// [Trial] object that provides information about the trial.
  Trial trial;

  /// [Parser] object that parses the input `data` string.
  Parser? parser;

  /// [Processor] object that processes the parsed data.
  Processor? processor;

  /// [Analyzer] object that analyzes the processed data.
  Analyzer? analyzer;

  /// Feeds the data into the pipeline to start processing.
  /// Throws an exception if the input data cannot be parsed or processed.
  void feed() {
    parser = Parser.run(data);
    if (parser != null &&
        parser!.parsedData != null &&
        parser!.parsedData!.isNotEmpty) {
      processor = Processor.run(parser!.parsedData!);

      if (processor != null) {
        analyzer = Analyzer.run(processor!.filteredData!, user, trial);
      } else {
        throw Exception('Cannot process the filtered data.');
      }
    } else {
      throw Exception('Cannot parse the input data.');
    }
  }
}
