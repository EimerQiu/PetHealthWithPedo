/*
 * Copyright 2023 POPULAR HEALTH LLC.
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:pedometer_flutter/pedometer_flutter.dart';
import 'package:test/test.dart';

void main() {
  group('Trial', () {
    test('Create', () {
      final trial = Trial(name: 'walk 1 ', rate: 5, steps: 10);
      
      expect(trial.name, equals('walk1'));
      expect(trial.rate, equals(5));
      expect(trial.steps, equals(10));
    });

    test('Create empty name', () {
      final emptyNameCases = ['', ' '];
      const message = 'Exception: Invalid name';
      for (final name in emptyNameCases) {
        expect(
          () => Trial(name: name),
          throwsA(predicate((e) => e.toString() == message)),
        );
      }
    });

    test('Create with rate', () {
      expect(Trial(name: 'walk1').rate, null);

      final invalidRateCases = [0, -1];
      const message = 'Exception: Invalid rate';
      for (final rate in invalidRateCases) {
        expect(
          () => Trial(name: 'walk1', rate: rate),
          throwsA(predicate((e) => e.toString() == message)),
        );
      }

      expect(Trial(name: 'walk1', rate: 1).rate, equals(1));
      expect(Trial(name: 'walk1', rate: 100).rate, equals(100));
    });

    test('Create With Steps', () {
      expect(Trial(name: 'walk1').steps, null);

      final invalidSteps = <int>[-1];
      const message = 'Exception: Invalid steps';
      for (final steps in invalidSteps) {
        expect(
          () => Trial(name: 'walk1', steps: steps),
          throwsA(predicate((e) => e.toString() == message)),
        );
      }

      expect(Trial(name: 'walk1', steps: 0).steps, equals(0));
      expect(Trial(name: 'walk1', steps: 1).steps, equals(1));
      expect(Trial(name: 'walk1', steps: 100).steps, equals(100));
    });
  });
}
