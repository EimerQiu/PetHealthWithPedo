/*
 * Copyright 2023 POPULAR HEALTH LLC.
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:pedometer_flutter/pedometer_flutter.dart';
import 'package:test/test.dart';

void main() {
  group('Filter tests', () {
    test('Filter gravity', () {
      final data = [0.123, 0.456, -0.212];
      final expected = [0, 0, 7.109485333219216e-05];

       expect(Filter.low0Hz(data), expected);
    });

    test('Filter smoothing', () {
      final data = [0.0, 0.0, 0.0005219529804999682];
      final expected = [0, 0, 4.9828746074755684e-05];

      expect(Filter.low5Hz(data), expected);
    });

    test('Filter highpass', () {
      final data = <double>[0, 0, 4.9828746074755684e-05];
      final expected = [0, 0, 4.753597533351234e-05];

      expect(Filter.high1Hz(data), expected);
    });
  });
}
