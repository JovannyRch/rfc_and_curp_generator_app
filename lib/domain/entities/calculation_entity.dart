class CalculationEntity {
  final String id;
  final String type; // 'CURP' or 'RFC'
  final String firstName;
  final String lastName;
  final String secondLastName;
  final DateTime birthDate;
  final String gender;
  final String state;
  final String result;
  final DateTime createdAt;

  CalculationEntity({
    required this.id,
    required this.type,
    required this.firstName,
    required this.lastName,
    required this.secondLastName,
    required this.birthDate,
    required this.gender,
    required this.state,
    required this.result,
    required this.createdAt,
  });
}