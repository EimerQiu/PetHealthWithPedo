/*
 * Copyright 2023 POPULAR HEALTH LLC.
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:pedometer_flutter/pedometer_flutter.dart';
import 'package:test/test.dart';

void main() {
  group('UserTest', () {
    test('create', () {
      final user = User(gender: 'male', height: 167.5, stride: 80);

      expect(user.gender, equals('male'));
      expect(user.height, equals(167.5));
      expect(user.stride, equals(80));
    });

    test('create_no_params', () {
      final user = User();

      expect(user.gender, null);
      expect(user.height, null);
      expect(user.stride, equals(74));
    });

    test('create_with_gender', () {
      expect(User().gender, null);

      final invalidGenders = ['Invalid gender'];
      const message = 'Exception: Invalid gender';
      for (final gender in invalidGenders) {
        expect(
          () => User(gender: gender),
          throwsA(predicate((e) => e.toString() == message)),
        );
      }

      expect(User(gender: 'Female').gender, equals('female'));
      expect(User(gender: 'MALE').gender, equals('male'));
    });

    test('create_with_height', () {
      expect(User().height, null);

      final invalidHeights = [0.0, -1.0];
      const message = 'Exception: Invalid height';
      for (final height in invalidHeights) {
        expect(
          () => User(height: height),
          throwsA(predicate((e) => e.toString() == message)),
        );
      }

      expect(User(height: 150).height, equals(150));
      expect(User(height: 167.5).height, equals(167.5));
      expect(User(height: 181.12).height, equals(181.12));
    });

    test('Test create with stride', () {
      expect(User().stride, 74);

      final strides = [0.0, -1.0];
      for (final stride in strides) {
        try {
          User(stride: stride);
        } catch (e) {
          expect(e.toString(), 'Exception: Invalid stride');
        }
      }

      expect(User(stride: 80).stride, 80);
      expect(User(stride: 75.25).stride, 75.25);
    });

    test('Test create with height and gender', () {
      expect(User(gender: 'male', height: 1).stride, 0.415);
      expect(User(gender: 'female', height: 1).stride, 0.413);
    });

    test('Test calculate stride', () {
      expect(User().stride, 74);
      expect(User(gender: 'male').stride, 78);
      expect(User(gender: 'female').stride, 70);
      expect(User(height: 200).stride, 82.8);
      expect(User(gender: 'male', height: 200).stride, 83);
      expect(User(gender: 'female', height: 200).stride, 82.6);
    });
  });
}
