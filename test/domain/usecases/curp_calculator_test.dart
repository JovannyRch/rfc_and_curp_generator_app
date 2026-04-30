import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:rfc_and_curp_helper/domain/usecases/curp_calculator.dart';

void main() {
  group('CurpCalculator.calculate', () {
    test('matches the upstream curp README example', () {
      final curp = CurpCalculator.calculate(
        firstName: 'Andrés Manuel',
        lastName: 'López',
        secondLastName: 'Obrador',
        birthDate: DateTime(1953, 11, 13),
        gender: 'MALE',
        state: 'Tabasco',
      );

      expect(curp, 'LOOA531113HTCPBN07');
    });

    test('matches Felipe Calderon upstream example', () {
      final curp = CurpCalculator.calculate(
        firstName: 'Felipe de Jesús',
        lastName: 'Calderón',
        secondLastName: 'Hinojosa',
        birthDate: DateTime(1962, 8, 18),
        gender: 'MALE',
        state: 'Michoacán',
      );

      expect(curp, 'CAHF620818HMNLNL09');
    });

    test('matches Enrique Pena Nieto upstream example', () {
      final curp = CurpCalculator.calculate(
        firstName: 'Enrique',
        lastName: 'Peña',
        secondLastName: 'Nieto',
        birthDate: DateTime(1966, 7, 20),
        gender: 'MALE',
        state: 'Estado De Mexico',
      );

      expect(curp, 'PXNE660720HMCXTN06');
    });

    test('matches upstream example without maternal surname', () {
      final curp = CurpCalculator.calculate(
        firstName: 'Luis',
        lastName: 'Perez',
        secondLastName: '',
        birthDate: DateTime(1975, 9, 9),
        gender: 'MALE',
        state: 'Ciudad de México',
      );

      expect(curp, 'PEXL750909HDFRXS02');
    });

    test('uses second name after MARIA compound prefix like upstream', () {
      final curp = CurpCalculator.calculate(
        firstName: 'MARIA ERNESTINA RAFAELA',
        lastName: 'CONTRERAS',
        secondLastName: 'MORALES',
        birthDate: DateTime(1972, 11, 10),
        gender: 'FEMALE',
        state: 'Veracruz',
      );

      expect(curp, 'COME721110MVZNRR03');
    });

    test('normalizes accents and spaces before generating CURP', () {
      final curp = CurpCalculator.calculate(
        firstName: '  Andrés   Manuel ',
        lastName: ' López ',
        secondLastName: ' Obrador ',
        birthDate: DateTime(1953, 11, 13),
        gender: 'MALE',
        state: 'Tabasco',
      );

      expect(curp, 'LOOA531113HTCPBN07');
    });

    test('supports non-binary gender using X code', () {
      final curp = CurpCalculator.calculate(
        firstName: 'JESÚS OCIEL',
        lastName: 'BAENA',
        secondLastName: 'SAUCEDO',
        birthDate: DateTime(1984, 12, 9),
        gender: 'NON_BINARY',
        state: 'Coahuila',
      );

      expect(curp, 'BASJ841209XCLNCS02');
    });
  });

  group('CurpCalculator.validate', () {
    test('returns true for known valid CURPs', () {
      expect(CurpCalculator.validate('PXNE660720HMCXTN06'), isTrue);
      expect(CurpCalculator.validate('LOOA531113HTCPBN07'), isTrue);
      expect(CurpCalculator.validate('BASJ841209XCLNCS02'), isTrue);
    });

    test('returns false for invalid verification digit', () {
      expect(CurpCalculator.validate('XARA750909HDFNDL01'), isFalse);
    });
  });

  group('CurpCalculator.generateRandomProfile', () {
    test('returns a self-consistent random CURP profile', () {
      final profile = CurpCalculator.generateRandomProfile(random: Random(42));

      expect(profile.curp, hasLength(18));
      expect(
        profile.curp,
        CurpCalculator.calculate(
          firstName: profile.firstName,
          lastName: profile.lastName,
          secondLastName: profile.secondLastName,
          birthDate: profile.birthDate,
          gender: profile.gender,
          state: profile.state,
        ),
      );
      expect(CurpCalculator.validate(profile.curp), isTrue);
    });
  });
}
