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
  static const Set<String> _commonNames = {
    'JOSE',
    'MARIA',
    'MA',
    'MA.',
  };

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

  static const String _homoclaveDigits =
      '123456789ABCDEFGHIJKLMNPQRSTUVWXYZ';

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
    final mappedFullName = '0${_normalizeForHomoclave(fullName).split('').map((c) => _homoclaveMap[c] ?? '').join()}';

    var sum = 0;
    for (var index = 0; index < mappedFullName.length - 1; index++) {
      final firstPair = int.parse(mappedFullName.substring(index, index + 2));
      final secondPair = int.parse(mappedFullName.substring(index + 1, index + 2));
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
