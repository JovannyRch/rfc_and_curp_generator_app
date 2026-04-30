import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:rfc_and_curp_helper/core/constants/mexican_states.dart';
import 'package:web/web.dart' as web;

import 'curp_calculator_native.dart' as native;

String calculateCurp({
  required String firstName,
  required String lastName,
  required String secondLastName,
  required DateTime birthDate,
  required String gender,
  required String state,
}) {
  try {
    final curp = web.window.getProperty<JSObject?>('curp'.toJS);
    if (curp == null) {
      return native.calculateCurp(
        firstName: firstName,
        lastName: lastName,
        secondLastName: secondLastName,
        birthDate: birthDate,
        gender: gender,
        state: state,
      );
    }

    final persona = curp.callMethod<JSObject>('getPersona'.toJS);
    persona.setProperty('nombre'.toJS, firstName.trim().toJS);
    persona.setProperty('apellidoPaterno'.toJS, lastName.trim().toJS);
    persona.setProperty('apellidoMaterno'.toJS, secondLastName.trim().toJS);
    persona.setProperty('genero'.toJS, _genderCode(gender).toJS);
    persona.setProperty('estado'.toJS, MexicanStates.getCode(state).toJS);
    persona.setProperty(
      'fechaNacimiento'.toJS,
      _formatBirthDate(birthDate).toJS,
    );

    final result = curp.callMethod<JSString?>(
      'generar'.toJS,
      <JSAny?>[persona].toJS,
    );
    final dartResult = result?.toDart;
    if (dartResult != null && dartResult.isNotEmpty) {
      return dartResult;
    }
  } catch (_) {
    // Keep native platforms and script-load failures functional.
  }

  return native.calculateCurp(
    firstName: firstName,
    lastName: lastName,
    secondLastName: secondLastName,
    birthDate: birthDate,
    gender: gender,
    state: state,
  );
}

bool validateCurp(String curp) {
  try {
    final curpLibrary = web.window.getProperty<JSObject?>('curp'.toJS);
    if (curpLibrary == null) {
      return native.validateCurp(curp);
    }

    final result = curpLibrary.callMethod<JSBoolean>(
      'validar'.toJS,
      [curp.toJS].toJS,
    );
    return result.toDart;
  } catch (_) {
    return native.validateCurp(curp);
  }
}

String _formatBirthDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day-$month-${date.year}';
}

String _genderCode(String gender) {
  return switch (gender.toUpperCase()) {
    'MALE' => 'H',
    'FEMALE' => 'M',
    'NON_BINARY' => 'X',
    _ => 'M',
  };
}
