/*
 * Copyright 2023 POPULAR HEALTH LLC.
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:pedometer_flutter/pedometer_flutter.dart';
import 'package:test/test.dart';

void main() {
  test('Test new', () {
    const data = '0.123,-0.123,5;0.456,-0.789,0.111;-0.212,0.001,1;';
    final parser = Parser(data: data);

    expect(parser.parsedData, null);
  });

  test('Test create combined data', () {
    const data = '0.123,-0.123,5;0.456,-0.789,0.111;-0.212,0.001,1;';
    final parser = Parser.run(data);

    expect(parser.parsedData, [
      [
        [0.123, -0.123, 5.0],
        [0, 0, 0]
      ],
      [
        [0.456, -0.789, 0.111],
        [0, 0, 0]
      ],
      [
        [-0.2120710948533322, 0.0011468544965549535, 0.9994625125426089],
        [7.109485333219216e-05, -0.00014685449655495343, 0.0005374874573911294]
      ]
    ]);
  });

  test('Test create separated data', () {
    const data =
        '0.028,-0.072,5|0.129,-0.945,-5;0,-0.07,0.06|0.123,-0.947,5;0.2,-1,2|0.1,-0.9,3;';
    final parser = Parser.run(data);

    expect(parser.parsedData, [
      [
        [0.028, -0.072, 5],
        [0.129, -0.945, -5]
      ],
      [
        [0, -0.07, 0.06],
        [0.123, -0.947, 5]
      ],
      [
        [0.2, -1.0, 2.0],
        [0.1, -0.9, 3.0]
      ]
    ]);
  });

  test('Test create string values parses to 0s', () {
    var data = '1,2,foo;';
    var parser = Parser.run(data);
    expect(parser.parsedData, [
      [
        [1.0, 2.0, 0.0],
        [0, 0, 0]
      ]
    ]);

    data = '1,2,foo|4,bar,6;';
    parser = Parser.run(data);
    expect(parser.parsedData, [
      [
        [1.0, 2.0, 0.0],
        [4.0, 0.0, 6.0]
      ]
    ]);
  });

  test('test_create_empty', () {
    const message = 'Exception: Bad Input. Ensure data is properly formatted.';
    expect(
      () => Parser.run(''),
      throwsA(predicate((e) => e.toString() == message)),
    );
  });

  test('test_create_bad_input_too_many_values', () {
    const message = 'Exception: Bad Input. Ensure data is properly formatted.';
    expect(
      () => Parser.run('0.123,-0.123,5;0.123,-0.123,5,9;'),
      throwsA(predicate((e) => e.toString() == message)),
    );
    expect(
      () => Parser.run(
        '0.028,-0.072,5,6|0.129,-0.945,-5;0,-0.07,0.06|0.123,-0.947,5;',
      ),
      throwsA(predicate((e) => e.toString() == message)),
    );
  });

  test('test_create_bad_input_too_few_values', () {
    const message = 'Exception: Bad Input. Ensure data is properly formatted.';
    expect(
      () => Parser.run('0.123,-0.123,5;0.123,-0.123;'),
      throwsA(predicate((e) => e.toString() == message)),
    );
    expect(
      () => Parser.run(
        '0.028,-0.072,5|0.129,-0.945,-5;0,-0.07,0.06|0.123,-0.947;',
      ),
      throwsA(predicate((e) => e.toString() == message)),
    );
  });

  test('test_create_bad_input_delimiters', () {
    const message = 'Exception: Bad Input. Ensure data is properly formatted.';
    expect(
      () => Parser.run('1,2,3:4,5,6:'),
      throwsA(predicate((e) => e.toString() == message)),
    );
    expect(
      () => Parser.run('1,2,3;4:5,6;'),
      throwsA(predicate((e) => e.toString() == message)),
    );
    expect(
      () => Parser.run('1,2,3!4,5,6;'),
      throwsA(predicate((e) => e.toString() == message)),
    );
  });
}
