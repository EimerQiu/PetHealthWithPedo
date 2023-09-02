/*
 * Copyright 2023 POPULAR HEALTH LLC.
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'dart:io';
import 'package:pedometer_flutter/pedometer_flutter.dart';
import 'package:test/test.dart';

void main() {
  test('new_combined_data', () {
    const filePath = 'data/D45B8D9572EB_1681017831271_gyroAccCombined_data.txt';
    final file = File(filePath);

    final user = User();
    final trial = Trial(name: 'foobar1', rate: 100);
    final pipeline = Pipeline.run(file.readAsStringSync(), user, trial);

    expect(user, equals(pipeline.user));
    expect(trial, equals(pipeline.trial));
    expect(pipeline.parser != null, true);
    expect(pipeline.processor != null, true);
    expect(pipeline.analyzer != null, true);

    expect(pipeline.analyzer!.steps, equals(12));
    expect(pipeline.analyzer!.distance, equals(888.0));
    expect(pipeline.analyzer!.time, equals(8.63));
  });

  test('new_separated_data', () {
    const filePath = 'data/D45B8D9572EB_1681017831271_gyroAccCombined_data.txt';
    final file = File(filePath);

    final user = User();
    final trial = Trial(name: 'foobar1', rate: 100);
    final pipeline = Pipeline.run(file.readAsStringSync(), user, trial);

    expect(user, equals(pipeline.user));
    expect(trial, equals(pipeline.trial));
    expect(pipeline.parser != null, true);
    expect(pipeline.processor != null, true);
    expect(pipeline.analyzer != null, true);

    expect(pipeline.analyzer!.steps, equals(12));
    expect(pipeline.analyzer!.distance, equals(888.0));
    expect(pipeline.analyzer!.time, equals(9.31));
  });
}
