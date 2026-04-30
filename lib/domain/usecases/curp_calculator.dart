import 'curp_calculator_native.dart'
    if (dart.library.html) 'curp_calculator_web.dart'
    as impl;

class CurpCalculator {
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
}
