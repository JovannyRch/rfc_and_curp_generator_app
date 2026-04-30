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
  });
}
