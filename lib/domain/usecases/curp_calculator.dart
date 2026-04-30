import 'package:rfc_and_curp_helper/core/constants/mexican_states.dart';

class CurpCalculator {
  static String calculate({
    required String firstName,
    required String lastName,
    required String secondLastName,
    required DateTime birthDate,
    required String gender,
    required String state,
  }) {
    final firstNameUpper = firstName.toUpperCase().trim();
    final lastNameUpper = lastName.toUpperCase().trim();
    final secondLastNameUpper = secondLastName.toUpperCase().trim();

    final initials = _getInitials(lastNameUpper, secondLastNameUpper, firstNameUpper);
    final vowel = _getFirstVowel(lastNameUpper);
    final birthDateStr = _formatBirthDate(birthDate);
    final genderCode = gender.toUpperCase() == 'MALE' ? 'H' : 'M';
    final stateCode = MexicanStates.getCode(state);
    final homoclave = 'X0';
    final verificationDigit = '0';

    return '$initials$vowel$birthDateStr$genderCode$stateCode$homoclave$verificationDigit';
  }

  static String _getInitials(String lastName, String secondLastName, String firstName) {
    final lastNameFirst = lastName.isNotEmpty ? lastName[0] : '';
    final secondLastNameFirst = secondLastName.isNotEmpty ? secondLastName[0] : '';
    final firstNameFirst = firstName.isNotEmpty ? firstName[0] : '';

    return '$lastNameFirst$secondLastNameFirst$firstNameFirst';
  }

  static String _getFirstVowel(String lastName) {
    const vowels = ['A', 'E', 'I', 'O', 'U'];
    if (lastName.length <= 1) return 'X';
    for (int i = 1; i < lastName.length; i++) {
      final char = lastName[i];
      if (vowels.contains(char)) {
        return char;
      }
    }
    return 'X';
  }

  static String _formatBirthDate(DateTime date) {
    final year = date.year.toString().substring(2);
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year$month$day';
  }
}