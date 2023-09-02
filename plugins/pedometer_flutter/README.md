# Pedometer Flutter

[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis) 
=========
A Dart package that helps to process pedometer data, including steps count and rate of steps per second.

## Getting Started

### Prerequisites

This package requires Dart SDK 2.9.0 or later.

### Installing

Add the following dependency to your `pubspec.yaml` file:


And run the following command in your terminal:


### Using the package

The package includes several classes that help to process pedometer data:

- `Analyzer`: A class that analyzes the data and calculates various statistics.
- `Filter`: A class that filters the data based on certain criteria.
- `Parser`: A class that parses the data and converts it into a useful format.
- `Pipeline`: A class that combines several processing steps into a single process.
- `Processor`: A class that processes the data and prepares it for analysis.
- `Trial`: A class that represents a single trial of a pedometer measurement.
- `User`: A class that represents a user profile, which contains information about the gender, height, and stride length of the user.

## Example

Here is an example of how to use the package to process some pedometer data:

```dart
import 'package:pedometer_flutter/pedometer_flutter.dart';

void main() {
  // Create a user with gender, height and stride length
  User user = User(gender: 'male', height: 180, stride: 70);

  // Parse the data and convert it into a useful format
  List<Map<String, dynamic>> data = [
    {'name': 'Trial 1', 'rate': 100, 'steps': 1000},
    {'name': 'Trial 2', 'rate': 150, 'steps': 1500},
    {'name': 'Trial 3', 'rate': 120, 'steps': 1200},
  ];
  Parser parser = Parser();
  List<Trial> trials = parser.parse(data);

  // Filter the data based on certain criteria
  Filter filter = Filter();
  trials = filter.filterBySteps(trials, 1000, 1500);

  // Process the data and prepare it for analysis
  Processor processor = Processor(user: user);
  trials = processor.process(trials);

  // Analyze the data and calculate various statistics
  Analyzer analyzer = Analyzer();
  Map<String, dynamic> stats = analyzer.analyze(trials);
  
  print(stats);
}

flutter test

