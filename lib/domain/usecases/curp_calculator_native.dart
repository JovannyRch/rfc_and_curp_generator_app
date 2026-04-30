import 'package:rfc_and_curp_helper/core/constants/mexican_states.dart';

String calculateCurp({
  required String firstName,
  required String lastName,
  required String secondLastName,
  required DateTime birthDate,
  required String gender,
  required String state,
}) {
  _validateRequiredData(
    firstName: firstName,
    lastName: lastName,
    birthDate: birthDate,
    gender: gender,
    state: state,
  );

  final normalizedName = _adjustCompound(
    _normalizeString(firstName.toUpperCase()),
  ).trim();
  final normalizedLastName = _adjustCompound(
    _normalizeString(lastName.toUpperCase()),
  ).trim();
  final normalizedSecondLastName = _adjustCompound(
    _normalizeString(secondLastName.toUpperCase()),
  ).trim();
  final nameToUse = _nameToUse(normalizedName);

  var firstFour = [
    _safeInitial(normalizedLastName),
    _firstInternalVowel(normalizedLastName),
    _safeInitial(normalizedSecondLastName, fallback: 'X'),
    _safeInitial(nameToUse),
  ].join();

  firstFour = _filterCharacters(_replaceForbiddenWord(firstFour));

  final internalConsonants = _filterCharacters(
    [
      _firstInternalConsonant(normalizedLastName),
      _firstInternalConsonant(normalizedSecondLastName),
      _firstInternalConsonant(nameToUse),
    ].join(),
  );

  final year = birthDate.year.toString();
  final yearSuffix = year.substring(year.length - 2);
  final month = birthDate.month.toString().padLeft(2, '0');
  final day = birthDate.day.toString().padLeft(2, '0');
  final genderCode = _genderCode(gender);
  final stateCode = MexicanStates.getCode(state);

  final incompleteCurp = [
    firstFour,
    yearSuffix,
    month,
    day,
    genderCode,
    stateCode,
    internalConsonants,
    birthDate.year < 2000 ? '0' : 'A',
  ].join();

  return '$incompleteCurp${_verificationDigit(incompleteCurp)}';
}

bool validateCurp(String curp) {
  final normalized = curp.trim().toUpperCase();
  final match = RegExp(
    r'^([A-Z][AEIOUX][A-Z]{2}\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])[HMX](?:AS|B[CS]|C[CLMSH]|D[FG]|G[TR]|HG|JC|M[CNS]|N[ETL]|OC|PL|Q[TR]|S[PLR]|T[CSL]|VZ|YN|ZS)[B-DF-HJ-NP-TV-Z]{3}[A-Z\d])(\d)$',
  ).firstMatch(normalized);
  if (match == null) {
    return false;
  }

  return _verificationDigit(match.group(1)!) == match.group(2);
}

const List<String> _commonNamePrefixes = [
  'MARIA DEL ',
  'MARIA DE LOS ',
  'MARIA ',
  'JOSE DE ',
  'JOSE ',
  'MA. ',
  'MA ',
  'M. ',
  'M ',
  'J. ',
  'J ',
];

void _validateRequiredData({
  required String firstName,
  required String lastName,
  required DateTime birthDate,
  required String gender,
  required String state,
}) {
  if (firstName.trim().isEmpty) {
    throw ArgumentError('Nombre es requerido');
  }
  if (lastName.trim().isEmpty) {
    throw ArgumentError('Apellido Paterno es requerido');
  }
  if (gender.trim().isEmpty) {
    throw ArgumentError('Genero es requerido');
  }
  if (state.trim().isEmpty) {
    throw ArgumentError('Estado es requerido');
  }
  if (birthDate.year <= 0) {
    throw ArgumentError('Fecha de nacimiento es requerido');
  }
}

const Set<String> _compoundParts = {
  'DA',
  'DAS',
  'DE',
  'DEL',
  'DER',
  'DI',
  'DIE',
  'DD',
  'EL',
  'LA',
  'LOS',
  'LAS',
  'LE',
  'LES',
  'MAC',
  'MC',
  'VAN',
  'VON',
  'Y',
};

const Map<String, String> _forbiddenWords = {
  'BACA': 'BXCA',
  'BAKA': 'BXKA',
  'BUEI': 'BXEI',
  'BUEY': 'BXEY',
  'CACA': 'CXCA',
  'CACO': 'CXCO',
  'CAGA': 'CXGA',
  'CAGO': 'CXGO',
  'CAKA': 'CXKA',
  'CAKO': 'CXKO',
  'COGE': 'CXGE',
  'COGI': 'CXGI',
  'COJA': 'CXJA',
  'COJE': 'CXJE',
  'COJI': 'CXJI',
  'COJO': 'CXJO',
  'COLA': 'CXLA',
  'CULO': 'CXLO',
  'FALO': 'FXLO',
  'FETO': 'FXTO',
  'GETA': 'GXTA',
  'GUEI': 'GXEI',
  'GUEY': 'GXEY',
  'JETA': 'JXTA',
  'JOTO': 'JXTO',
  'KACA': 'KXCA',
  'KACO': 'KXCO',
  'KAGA': 'KXGA',
  'KAGO': 'KXGO',
  'KAKA': 'KXKA',
  'KAKO': 'KXKO',
  'KOGE': 'KXGE',
  'KOGI': 'KXGI',
  'KOJA': 'KXJA',
  'KOJE': 'KXJE',
  'KOJI': 'KXJI',
  'KOJO': 'KXJO',
  'KOLA': 'KXLA',
  'KULO': 'KXLO',
  'LILO': 'LXLO',
  'LOCA': 'LXCA',
  'LOCO': 'LXCO',
  'LOKA': 'LXKA',
  'LOKO': 'LXKO',
  'MAME': 'MXME',
  'MAMO': 'MXMO',
  'MEAR': 'MXAR',
  'MEAS': 'MXAS',
  'MEON': 'MXON',
  'MIAR': 'MXAR',
  'MION': 'MXON',
  'MOCO': 'MXCO',
  'MOKO': 'MXKO',
  'MULA': 'MXLA',
  'MULO': 'MXLO',
  'NACA': 'NXCA',
  'NACO': 'NXCO',
  'PEDA': 'PXDA',
  'PEDO': 'PXDO',
  'PENE': 'PXNE',
  'PIPI': 'PXPI',
  'PITO': 'PXTO',
  'POPO': 'PXPO',
  'PUTA': 'PXTA',
  'PUTO': 'PXTO',
  'QULO': 'QXLO',
  'RATA': 'RXTA',
  'ROBA': 'RXBA',
  'ROBE': 'RXBE',
  'ROBO': 'RXBO',
  'RUIN': 'RXIN',
  'SENO': 'SXNO',
  'TETA': 'TXTA',
  'VACA': 'VXCA',
  'VAGA': 'VXGA',
  'VAGO': 'VXGO',
  'VAKA': 'VXKA',
  'VUEI': 'VXEI',
  'VUEY': 'VXEY',
  'WUEI': 'WXEI',
  'WUEY': 'WXEY',
};

String _adjustCompound(String input) {
  return input
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty && !_compoundParts.contains(part))
      .join(' ');
}

String _normalizeString(String input) {
  return input
      .replaceAll('Ã', 'A')
      .replaceAll('À', 'A')
      .replaceAll('Á', 'A')
      .replaceAll('Ä', 'A')
      .replaceAll('Â', 'A')
      .replaceAll('È', 'E')
      .replaceAll('É', 'E')
      .replaceAll('Ë', 'E')
      .replaceAll('Ê', 'E')
      .replaceAll('Ì', 'I')
      .replaceAll('Í', 'I')
      .replaceAll('Ï', 'I')
      .replaceAll('Î', 'I')
      .replaceAll('Ò', 'O')
      .replaceAll('Ó', 'O')
      .replaceAll('Ö', 'O')
      .replaceAll('Ô', 'O')
      .replaceAll('Ù', 'U')
      .replaceAll('Ú', 'U')
      .replaceAll('Ü', 'U')
      .replaceAll('Û', 'U')
      .replaceAll('Ç', 'C');
}

String _nameToUse(String normalizedName) {
  final compactName = normalizedName.trim();
  if (compactName.isEmpty) {
    return 'X';
  }

  final parts = compactName.split(RegExp(r'\s+'));
  final usesCommonPrefix =
      parts.length > 1 && _commonNamePrefixes.any(compactName.startsWith);
  if (usesCommonPrefix) {
    return parts[1];
  }

  return parts.first;
}

String _safeInitial(String value, {String fallback = 'X'}) {
  if (value.isEmpty) {
    return fallback;
  }

  final initial = value[0];
  return initial == 'Ñ' ? 'X' : initial;
}

String _firstInternalVowel(String value) {
  if (value.length <= 1) {
    return 'X';
  }

  final match = RegExp(r'[AEIOU]').firstMatch(value.substring(1));
  return match?.group(0) ?? 'X';
}

String _firstInternalConsonant(String value) {
  if (value.length <= 1) {
    return 'X';
  }

  final consonant = value
      .substring(1)
      .replaceAll(RegExp(r'[AEIOU]', caseSensitive: false), '')
      .substring(0, 1)
      .trim();
  if (consonant.isEmpty || consonant == 'Ñ') {
    return 'X';
  }
  return consonant;
}

String _replaceForbiddenWord(String value) {
  return _forbiddenWords[value] ?? value;
}

String _filterCharacters(String value) {
  return value.toUpperCase().replaceAll(RegExp(r'[\d_\-./\\,]'), 'X');
}

String _verificationDigit(String incompleteCurp) {
  const dictionary = '0123456789ABCDEFGHIJKLMNÑOPQRSTUVWXYZ';
  var sum = 0;

  for (var index = 0; index < 17; index++) {
    sum += dictionary.indexOf(incompleteCurp[index]) * (18 - index);
  }

  final digit = 10 - (sum % 10);
  return digit == 10 ? '0' : '$digit';
}

String _genderCode(String gender) {
  return switch (gender.toUpperCase()) {
    'MALE' => 'H',
    'FEMALE' => 'M',
    'NON_BINARY' => 'X',
    _ => 'M',
  };
}
