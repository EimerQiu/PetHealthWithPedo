/*
 * Copyright 2023 POPULAR HEALTH LLC.
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:pedometer_flutter/pedometer_flutter.dart';
import 'package:test/test.dart';

void main() {
  group('Processor', () {
    test('new', () {
      const data = '0.123,-0.123,5;0.456,-0.789,0.111;-0.212,0.001,1;';
      final parser = Parser.run(data);
      final processor = Processor.run(parser.parsedData!);

      expect(processor.dotProductData, [0.0, 0.0, 0.0005219529804999682]);
      expect(processor.filteredData, [0, 0, 4.753597533351234e-05]);
    });

    test('create_combined_data', () {
      const data = '0.123,-0.123,5;0.456,-0.789,0.111;-0.212,0.001,1;';
      final parser = Parser.run(data);
      final processor = Processor.run(parser.parsedData!);

      expect(processor.dotProductData, [0.0, 0.0, 0.0005219529804999682]);
      expect(processor.filteredData, [0, 0, 4.753597533351234e-05]);
    });

    test('create_separated_data', () {
      const data =
          '0.028,-0.072,5|0.129,-0.945,-5;0,-0.07,0.06|0.123,-0.947,5;0.2,-1,2|0.1,-0.9,3;';
      final parser = Parser.run(data);
      final processor = Processor.run(parser.parsedData!);

      expect(processor.dotProductData, [-24.928348, 0.36629, 6.92]);
      expect(processor.filteredData, [0, 0, -1.7004231121083724]);
    });
  });
}
