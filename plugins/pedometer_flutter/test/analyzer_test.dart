/*
 * Copyright 2023 POPULAR HEALTH LLC.
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'dart:io';

import 'package:pedometer_flutter/pedometer_flutter.dart';
import 'package:test/test.dart';

void main() {
  test('Test new analyzer', () {
    final analyzer =
        Analyzer(data: [0, 0], user: User(), trial: Trial(name: 'walk1'));

    expect(analyzer.steps, null);
    expect(analyzer.distance, null);
    expect(analyzer.time, null);
  });

  test('Test creation of analyzer', () {
    final data = <double>[
      0,
      0,
      3.0950446845522207e-05,
      8.888784491236883e-05,
      0.00017675661757108235,
      0.0003010710258273255,
      0.0004670334044406543,
      0.0006857659826903315
    ];
    final analyzer = Analyzer.run(data, User(), Trial(name: 'walk1'));

    expect(analyzer.delta, null);
    expect(analyzer.time, null);
    expect(analyzer.steps, 0);
    expect(analyzer.distance, 0);
  });

  test('Test creation of analyzer with non-zero data', () {
    const filePath = 'data/female-167-70_walk2-100-10.txt';
    final file = File(filePath);

    final user = User(gender: 'female', height: 167, stride: 70);
    final trial = Trial(name: 'walk 1', rate: 100, steps: 18);
    final parser = Parser.run(file.readAsStringSync());
    final processor = Processor.run(parser.parsedData!);
    final analyzer = Analyzer.run(processor.filteredData!, user, trial);

    expect(analyzer.steps, 10);
    expect(analyzer.delta, -8);
    expect(analyzer.distance, 700);
    expect(analyzer.time, 1037 / 100);
  });
}
