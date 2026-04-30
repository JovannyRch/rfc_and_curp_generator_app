import 'package:hive/hive.dart';

part 'calculation_model.g.dart';

@HiveType(typeId: 0)
class CalculationModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String type;

  @HiveField(2)
  late String firstName;

  @HiveField(3)
  late String lastName;

  @HiveField(4)
  late String secondLastName;

  @HiveField(5)
  late DateTime birthDate;

  @HiveField(6)
  late String gender;

  @HiveField(7)
  late String state;

  @HiveField(8)
  late String result;

  @HiveField(9)
  late DateTime createdAt;

  CalculationModel();

  CalculationModel.create({
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