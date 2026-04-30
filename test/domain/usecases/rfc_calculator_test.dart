import 'package:flutter_test/flutter_test.dart';
import 'package:rfc_and_curp_helper/domain/usecases/rfc_calculator.dart';

void main() {
  group('RfcCalculator.calculate', () {
    test('matches the README natural person example', () {
      final rfc = RfcCalculator.calculate(
        firstName: 'Josué',
        paternalLastName: 'Zarzosa',
        maternalLastName: 'de la Torre',
        birthDate: DateTime(1987, 8, 5),
      );

      expect(rfc, 'ZATJ870805CK6');
    });

    test('matches known RFC with verification digit 1', () {
      final rfc = RfcCalculator.calculate(
        firstName: 'Eliud',
        paternalLastName: 'Orozco',
        maternalLastName: 'Gomez',
        birthDate: DateTime(1952, 7, 11),
      );

      expect(rfc, 'OOGE520711151');
    });

    test('matches known RFC with verification digit A', () {
      final rfc = RfcCalculator.calculate(
        firstName: 'Saturnina',
        paternalLastName: 'Angel',
        maternalLastName: 'Cruz',
        birthDate: DateTime(1921, 11, 12),
      );

      expect(rfc, 'AECS211112JPA');
    });

    test('uses second given name for JOSE compound names', () {
      final rfc = RfcCalculator.calculate(
        firstName: 'José Antonio',
        paternalLastName: 'Camargo',
        maternalLastName: 'Hernández',
        birthDate: DateTime(1970, 12, 13),
      );

      expect(rfc.startsWith('CAHA701213'), isTrue);
      expect(rfc, hasLength(13));
    });

    test('uses second given name for MARIA compound names', () {
      final rfc = RfcCalculator.calculate(
        firstName: 'María Luisa',
        paternalLastName: 'Ramírez',
        maternalLastName: 'Sánchez',
        birthDate: DateTime(1970, 12, 13),
      );

      expect(rfc.startsWith('RASL701213'), isTrue);
      expect(rfc, hasLength(13));
    });

    test('handles missing maternal last name', () {
      final rfc = RfcCalculator.calculate(
        firstName: 'Gerarda',
        paternalLastName: 'Zafra',
        maternalLastName: '',
        birthDate: DateTime(1970, 12, 13),
      );

      expect(rfc.startsWith('ZAGE701213'), isTrue);
      expect(rfc, hasLength(13));
    });

    test('filters surname particles', () {
      final rfc = RfcCalculator.calculate(
        firstName: 'Josue',
        paternalLastName: 'de la Torre',
        maternalLastName: 'Zarzosa',
        birthDate: DateTime(1970, 12, 13),
      );

      expect(rfc.startsWith('TOZJ701213'), isTrue);
    });

    test('replaces offensive prefixes with X in fourth position', () {
      final rfc = RfcCalculator.calculate(
        firstName: 'Ingrid',
        paternalLastName: 'Bueno',
        maternalLastName: 'Ezquerra',
        birthDate: DateTime(1970, 12, 13),
      );

      expect(rfc.startsWith('BUEX701213'), isTrue);
    });

    test('normalizes accents and spaces before generating RFC', () {
      final rfc = RfcCalculator.calculate(
        firstName: '  José Ángel  ',
        paternalLastName: ' Núñez ',
        maternalLastName: ' Gómez ',
        birthDate: DateTime(1990, 1, 9),
      );

      expect(rfc.startsWith('NUGA900109'), isTrue);
      expect(rfc, hasLength(13));
    });
  });
}
