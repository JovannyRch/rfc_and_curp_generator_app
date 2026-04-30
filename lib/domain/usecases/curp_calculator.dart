import 'dart:math';

import 'package:rfc_and_curp_helper/core/constants/mexican_states.dart';

import 'curp_calculator_native.dart'
    if (dart.library.html) 'curp_calculator_web.dart'
    as impl;

class CurpCalculator {
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

  static const List<String> _randomLastNames = [
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

  static const List<String> _randomGenders = ['MALE', 'FEMALE', 'NON_BINARY'];

  static String calculate({
    required String firstName,
    required String lastName,
    required String secondLastName,
    required DateTime birthDate,
    required String gender,
    required String state,
  }) {
    return impl.calculateCurp(
      firstName: firstName,
      lastName: lastName,
      secondLastName: secondLastName,
      birthDate: birthDate,
      gender: gender,
      state: state,
    );
  }

  static bool validate(String curp) {
    return impl.validateCurp(curp);
  }

  static RandomCurpProfile generateRandomProfile({Random? random}) {
    final source = random ?? Random();
    final firstName =
        _randomFirstNames[source.nextInt(_randomFirstNames.length)];
    final lastName = _randomLastNames[source.nextInt(_randomLastNames.length)];
    final secondLastName =
        _randomLastNames[source.nextInt(_randomLastNames.length)];
    final gender = _randomGenders[source.nextInt(_randomGenders.length)];
    final state = MexicanStates
        .states[source.nextInt(MexicanStates.states.length)]['name']!;
    final birthYear = 1950 + source.nextInt(55);
    final birthMonth = source.nextInt(12) + 1;
    final birthDay = source.nextInt(_daysInMonth(birthYear, birthMonth)) + 1;
    final birthDate = DateTime(birthYear, birthMonth, birthDay);

    return RandomCurpProfile(
      firstName: firstName,
      lastName: lastName,
      secondLastName: secondLastName,
      birthDate: birthDate,
      gender: gender,
      state: state,
      curp: calculate(
        firstName: firstName,
        lastName: lastName,
        secondLastName: secondLastName,
        birthDate: birthDate,
        gender: gender,
        state: state,
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
}

class RandomCurpProfile {
  const RandomCurpProfile({
    required this.firstName,
    required this.lastName,
    required this.secondLastName,
    required this.birthDate,
    required this.gender,
    required this.state,
    required this.curp,
  });

  final String firstName;
  final String lastName;
  final String secondLastName;
  final DateTime birthDate;
  final String gender;
  final String state;
  final String curp;
}
