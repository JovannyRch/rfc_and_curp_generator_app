import 'dart:math';

/// Generates an RFC for an individual following the same algorithmic rules
/// used by `rfc-facil-js`.
///
/// The SAT is the only authority that officially assigns an RFC. This result
/// should still be displayed in the app as an approximate reference.
///
/// Example:
/// ```dart
/// final rfc = RfcCalculator.calculate(
///   firstName: 'Josue',
///   paternalLastName: 'Zarzosa',
///   maternalLastName: 'de la Torre',
///   birthDate: DateTime(1987, 8, 5),
/// );
///
/// // ZATJ870805CK6
/// ```
class RfcCalculator {
  static const List<String> _randomFirstNames = [
    'Jose Antonio',
    'Maria Fernanda',
    'Luis',
    'Ana Sofia',
    'Carlos',
    'Daniela',
    'Jorge',
    'Paulina',
    'Miguel Angel',
    'Ximena',
  ];

  static const List<String> _randomPaternalLastNames = [
    'Hernandez',
    'Garcia',
    'Martinez',
    'Lopez',
    'Gonzalez',
    'Perez',
    'Sanchez',
    'Ramirez',
    'Torres',
    'Flores',
  ];

  static const List<String> _randomMaternalLastNames = [
    'Morales',
    'Jimenez',
    'Vargas',
    'Castillo',
    'Navarro',
    'Cruz',
    'Ortega',
    'Reyes',
    'Mendoza',
    'Romero',
  ];

  static const List<String> _juristicForbiddenWords = [
    'EL',
    'LA',
    'DE',
    'LOS',
    'LAS',
    'Y',
    'DEL',
    'MI',
    'POR',
    'CON',
    'SUS',
    'E',
    'PARA',
    'EN',
    'MC',
    'VON',
    'MAC',
    'VAN',
    'COMPANIA',
    'CIA',
    'CIA.',
    'SOCIEDAD',
    'SOC',
    'SOC.',
    'COMPANY',
    'CO',
    'SC',
    'SCL',
    'SCS',
    'SNC',
    'SRL',
    'CV',
    'SA',
    'THE',
    'OF',
    'AND',
    'A',
  ];

  static const Set<String> _commonNames = {'JOSE', 'MARIA', 'MA', 'MA.'};

  static const Set<String> _specialParticles = {
    'DE',
    'LA',
    'LAS',
    'MC',
    'VON',
    'DEL',
    'LOS',
    'Y',
    'MAC',
    'VAN',
    'MI',
  };

  static const Set<String> _forbiddenWords = {
    'BUEI',
    'BUEY',
    'CACA',
    'CACO',
    'CAGA',
    'CAGO',
    'COGE',
    'COJA',
    'COJE',
    'COJI',
    'COJO',
    'FETO',
    'JOTO',
    'KACA',
    'KACO',
    'KAGA',
    'KAGO',
    'KOGE',
    'KOJO',
    'KAKA',
    'MAME',
    'MAMO',
    'MEAR',
    'MEON',
    'MION',
    'MOCO',
    'MULA',
    'PEDA',
    'PEDO',
    'PENE',
    'PUTA',
    'PUTO',
    'QULO',
    'KULO',
    'RATA',
    'RUIN',
  };

  static const Map<String, String> _homoclaveMap = {
    ' ': '00',
    '0': '00',
    '1': '01',
    '2': '02',
    '3': '03',
    '4': '04',
    '5': '05',
    '6': '06',
    '7': '07',
    '8': '08',
    '9': '09',
    '&': '10',
    'A': '11',
    'B': '12',
    'C': '13',
    'D': '14',
    'E': '15',
    'F': '16',
    'G': '17',
    'H': '18',
    'I': '19',
    'J': '21',
    'K': '22',
    'L': '23',
    'M': '24',
    'N': '25',
    'O': '26',
    'P': '27',
    'Q': '28',
    'R': '29',
    'S': '32',
    'T': '33',
    'U': '34',
    'V': '35',
    'W': '36',
    'X': '37',
    'Y': '38',
    'Z': '39',
    'Ñ': '40',
  };

  static const String _homoclaveDigits = '123456789ABCDEFGHIJKLMNPQRSTUVWXYZ';

  static const Map<String, int> _verificationDigitMap = {
    '0': 0,
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    '6': 6,
    '7': 7,
    '8': 8,
    '9': 9,
    'A': 10,
    'B': 11,
    'C': 12,
    'D': 13,
    'E': 14,
    'F': 15,
    'G': 16,
    'H': 17,
    'I': 18,
    'J': 19,
    'K': 20,
    'L': 21,
    'M': 22,
    'N': 23,
    '&': 24,
    'O': 25,
    'P': 26,
    'Q': 27,
    'R': 28,
    'S': 29,
    'T': 30,
    'U': 31,
    'V': 32,
    'W': 33,
    'X': 34,
    'Y': 35,
    'Z': 36,
    ' ': 37,
    'Ñ': 38,
  };

  static final RegExp _naturalPersonRegex = RegExp(
    r'^[A-Z&Ñ]{4}\d{6}[A-Z0-9]{3}$',
  );

  static final RegExp _juristicPersonRegex = RegExp(
    r'^[A-Z&Ñ]{3}\d{6}[A-Z0-9]{3}$',
  );

  static String calculate({
    required String firstName,
    required String paternalLastName,
    String maternalLastName = '',
    required DateTime birthDate,
  }) {
    final tenDigitCode = _naturalPersonTenDigitsCode(
      firstName: firstName,
      paternalLastName: paternalLastName,
      maternalLastName: maternalLastName,
      birthDate: birthDate,
    );
    final homoclave = _calculateHomoclave(
      '$paternalLastName $maternalLastName $firstName',
    );
    final verificationDigit = _calculateVerificationDigit(
      '$tenDigitCode$homoclave',
    );

    return '$tenDigitCode$homoclave$verificationDigit';
  }

  static String calculateJuristicPerson({
    required String legalName,
    required DateTime creationDate,
  }) {
    final tenDigitCode = _juristicPersonTenDigitsCode(
      legalName: legalName,
      creationDate: creationDate,
    );
    final homoclave = _calculateHomoclave(legalName);
    final verificationDigit = _calculateVerificationDigit(
      ' $tenDigitCode$homoclave',
    );

    return '$tenDigitCode$homoclave$verificationDigit';
  }

  static bool validate(String rfc) {
    final normalized = rfc.trim().toUpperCase();

    if (_naturalPersonRegex.hasMatch(normalized)) {
      return _calculateVerificationDigit(normalized.substring(0, 12)) ==
          normalized.substring(12);
    }

    if (_juristicPersonRegex.hasMatch(normalized)) {
      return _calculateVerificationDigit(' ${normalized.substring(0, 11)}') ==
          normalized.substring(11);
    }

    return false;
  }

  static RandomRfcProfile generateRandomProfile({Random? random}) {
    final source = random ?? Random();
    final firstName =
        _randomFirstNames[source.nextInt(_randomFirstNames.length)];
    final paternalLastName =
        _randomPaternalLastNames[source.nextInt(
          _randomPaternalLastNames.length,
        )];
    final maternalLastName =
        _randomMaternalLastNames[source.nextInt(
          _randomMaternalLastNames.length,
        )];
    final birthYear = 1950 + source.nextInt(55);
    final birthMonth = source.nextInt(12) + 1;
    final birthDay = source.nextInt(_daysInMonth(birthYear, birthMonth)) + 1;
    final birthDate = DateTime(birthYear, birthMonth, birthDay);

    return RandomRfcProfile(
      firstName: firstName,
      paternalLastName: paternalLastName,
      maternalLastName: maternalLastName,
      birthDate: birthDate,
      rfc: calculate(
        firstName: firstName,
        paternalLastName: paternalLastName,
        maternalLastName: maternalLastName,
        birthDate: birthDate,
      ),
    );
  }

  static int _daysInMonth(int year, int month) {
    return switch (month) {
      2 => _isLeapYear(year) ? 29 : 28,
      4 || 6 || 9 || 11 => 30,
      _ => 31,
    };
  }

  static bool _isLeapYear(int year) {
    if (year % 400 == 0) return true;
    if (year % 100 == 0) return false;
    return year % 4 == 0;
  }

  static String _juristicPersonTenDigitsCode({
    required String legalName,
    required DateTime creationDate,
  }) {
    return '${_juristicNameCode(legalName)}${_dateCode(creationDate)}';
  }

  static String _juristicNameCode(String input) {
    final normalized = _removeAccents(input.toUpperCase().trim());
    final withoutType = normalized
        .replaceAll(RegExp(r'S\.?\s?EN\s?N\.?\s?C\.?$'), '')
        .replaceAll(RegExp(r'S\.?\s?EN\s?C\.?\s?POR\s?A\.?$'), '')
        .replaceAll(RegExp(r'S\.?\s?EN\s?C\.?$'), '')
        .replaceAll(RegExp(r'S\.?\s?DE\s?R\.?\s?L\.?$'), '')
        .replaceAll(RegExp(r'S\.?\s?DE\s?R\.?\s?L\.?\s?DE\s?C\.?\s?V\.?$'), '')
        .replaceAll(RegExp(r'S\.?\s?A\.?\s?DE\s?C\.?\s?V\.?$'), '')
        .replaceAll(
          RegExp(r'S\.?\s?A\.?\s?P\.?\s?I\.?\s?DE\s?C\.?\s?V\.?$'),
          '',
        )
        .replaceAll(RegExp(r'S\.?\s?A\.?\s?S\.?\s?DE\s?C\.?\s?V\.?$'), '')
        .replaceAll(RegExp(r'A\.?\s?EN\s?P\.?$'), '')
        .replaceAll(RegExp(r'S\.?\s?C\.?\s?[LPS]\.?$'), '')
        .replaceAll(RegExp(r'S\.?\s?[AC]\.?$'), '')
        .replaceAll(RegExp(r'S\.?\s?N\.?\s?C\.?$'), '')
        .replaceAll(RegExp(r'A\.?\s?C\.?$'), '');

    final words = withoutType
        .split(RegExp(r'[,\s]+'))
        .where((word) => word.isNotEmpty)
        .where((word) => !_juristicForbiddenWords.contains(word))
        .map(_normalizeJuristicWord)
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.length >= 3) {
      return '${words[0][0]}${words[1][0]}${words[2][0]}';
    }
    if (words.length == 2) {
      return '${words[0][0]}${_take(words[1], 2)}';
    }
    if (words.isEmpty) {
      return 'XXX';
    }
    return _take(words.first, 3);
  }

  static String _normalizeJuristicWord(String word) {
    final expandedSingleton = switch (word) {
      '@' => 'ARROBA',
      '´' => 'APOSTROFE',
      '%' => 'PORCIENTO',
      '#' => 'NUMERO',
      '!' => 'ADMIRACION',
      '.' => 'PUNTO',
      r'$' => 'PESOS',
      '"' => 'COMILLAS',
      '-' => 'GUION',
      '/' => 'DIAGONAL',
      '+' => 'SUMA',
      '(' => 'ABRE',
      ')' => 'CIERRA',
      _ => word,
    };

    return expandedSingleton
        .replaceAll(RegExp(r'(.+?)[@´%#!.$"\-/+()](.+?)'), r'$1$2')
        .replaceAll(RegExp(r'\.$'), '')
        .trim();
  }

  static String _naturalPersonTenDigitsCode({
    required String firstName,
    required String paternalLastName,
    required String maternalLastName,
    required DateTime birthDate,
  }) {
    final filteredName = _filteredGivenName(firstName);
    final normalizedPaternal = _normalizeForNameCode(paternalLastName);
    final normalizedMaternal = _normalizeForNameCode(maternalLastName);

    final code = switch ((
      normalizedPaternal.isEmpty,
      normalizedMaternal.isEmpty,
      normalizedPaternal.length <= 2,
    )) {
      (true, _, _) =>
        '${_take(normalizedMaternal, 2)}${_take(filteredName, 2)}',
      (_, true, _) =>
        '${_take(normalizedPaternal, 2)}${_take(filteredName, 2)}',
      (_, _, true) =>
        '${_charAtOrX(normalizedPaternal, 0)}'
            '${_charAtOrX(normalizedMaternal, 0)}'
            '${_take(filteredName, 2)}',
      _ =>
        '${_charAtOrX(normalizedPaternal, 0)}'
            '${_firstInternalVowel(normalizedPaternal)}'
            '${_charAtOrX(normalizedMaternal, 0)}'
            '${_charAtOrX(filteredName, 0)}',
    };

    return '${_obfuscateForbiddenWord(code)}${_dateCode(birthDate)}';
  }

  static String _filteredGivenName(String firstName) {
    final normalized = _normalizeForNameCode(firstName);
    final rawParts = firstName.trim().split(RegExp(r'\s+'));
    if (rawParts.length > 1) {
      final normalizedParts = normalized.split(' ');
      if (normalizedParts.length > 1 &&
          _commonNames.contains(normalizedParts.first)) {
        return normalizedParts.sublist(1).join(' ');
      }
    }
    return normalized;
  }

  static String _normalizeForNameCode(String input) {
    var normalized = _removeAccents(input.toUpperCase());
    normalized = normalized.replaceAll(RegExp(r'\s+'), '  ');
    for (final particle in _specialParticles) {
      normalized = normalized
          .replaceAll(RegExp('^$particle '), '')
          .replaceAll(' $particle ', ' ')
          .replaceAll(RegExp(' $particle\$'), '');
    }
    return normalized.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static String _removeAccents(String input) {
    return input
        .replaceAll('Á', 'A')
        .replaceAll('À', 'A')
        .replaceAll('Ä', 'A')
        .replaceAll('Â', 'A')
        .replaceAll('Ã', 'A')
        .replaceAll('É', 'E')
        .replaceAll('È', 'E')
        .replaceAll('Ë', 'E')
        .replaceAll('Ê', 'E')
        .replaceAll('Í', 'I')
        .replaceAll('Ì', 'I')
        .replaceAll('Ï', 'I')
        .replaceAll('Î', 'I')
        .replaceAll('Ó', 'O')
        .replaceAll('Ò', 'O')
        .replaceAll('Ö', 'O')
        .replaceAll('Ô', 'O')
        .replaceAll('Õ', 'O')
        .replaceAll('Ú', 'U')
        .replaceAll('Ù', 'U')
        .replaceAll('Ü', 'U')
        .replaceAll('Û', 'U');
  }

  static String _obfuscateForbiddenWord(String input) {
    if (_forbiddenWords.contains(input)) {
      return '${input.substring(0, 3)}X';
    }
    return input;
  }

  static String _firstInternalVowel(String input) {
    final match = RegExp(r'[AEIOU]').firstMatch(input.substring(1));
    return match?.group(0) ?? 'X';
  }

  static String _dateCode(DateTime date) {
    final year = date.year.toString().substring(2);
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year$month$day';
  }

  static String _take(String input, int count) {
    if (input.isEmpty) {
      return ''.padRight(count, 'X');
    }
    if (input.length >= count) {
      return input.substring(0, count);
    }
    return input.padRight(count, 'X');
  }

  static String _charAtOrX(String input, int index) {
    if (input.length <= index) {
      return 'X';
    }
    return input[index];
  }

  static String _calculateHomoclave(String fullName) {
    final mappedFullName =
        '0${_normalizeForHomoclave(fullName).split('').map((c) => _homoclaveMap[c] ?? '').join()}';

    var sum = 0;
    for (var index = 0; index < mappedFullName.length - 1; index++) {
      final firstPair = int.parse(mappedFullName.substring(index, index + 2));
      final secondPair = int.parse(
        mappedFullName.substring(index + 1, index + 2),
      );
      sum += firstPair * secondPair;
    }

    final lastThreeDigits = sum % 1000;
    final quotient = lastThreeDigits ~/ 34;
    final remainder = lastThreeDigits % 34;
    return '${_homoclaveDigits[quotient]}${_homoclaveDigits[remainder]}';
  }

  static String _normalizeForHomoclave(String input) {
    return input
        .toUpperCase()
        .replaceAll('Á', 'A')
        .replaceAll('À', 'A')
        .replaceAll('Ä', 'A')
        .replaceAll('Â', 'A')
        .replaceAll('Ã', 'A')
        .replaceAll('É', 'E')
        .replaceAll('È', 'E')
        .replaceAll('Ë', 'E')
        .replaceAll('Ê', 'E')
        .replaceAll('Í', 'I')
        .replaceAll('Ì', 'I')
        .replaceAll('Ï', 'I')
        .replaceAll('Î', 'I')
        .replaceAll('Ó', 'O')
        .replaceAll('Ò', 'O')
        .replaceAll('Ö', 'O')
        .replaceAll('Ô', 'O')
        .replaceAll('Õ', 'O')
        .replaceAll('Ú', 'U')
        .replaceAll('Ù', 'U')
        .replaceAll('Ü', 'U')
        .replaceAll('Û', 'U')
        .replaceAll(RegExp(r"[-\.',]"), '');
  }

  static String _calculateVerificationDigit(String rfc12Digits) {
    var sum = 0;
    final chars = rfc12Digits.split('');

    for (var index = 0; index < chars.length; index++) {
      final value = _verificationDigitMap[chars[index].toUpperCase()] ?? 0;
      sum += value * (13 - index);
    }

    final remainder = sum % 11;
    if (remainder == 0) {
      return '0';
    }

    final value = 11 - remainder;
    return value.toRadixString(16).toUpperCase();
  }
}

class RandomRfcProfile {
  const RandomRfcProfile({
    required this.firstName,
    required this.paternalLastName,
    required this.maternalLastName,
    required this.birthDate,
    required this.rfc,
  });

  final String firstName;
  final String paternalLastName;
  final String maternalLastName;
  final DateTime birthDate;
  final String rfc;
}
