// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation_model.dart';

class CalculationModelAdapter extends TypeAdapter<CalculationModel> {
  @override
  final int typeId = 0;

  @override
  CalculationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalculationModel()
      ..id = fields[0] as String
      ..type = fields[1] as String
      ..firstName = fields[2] as String
      ..lastName = fields[3] as String
      ..secondLastName = fields[4] as String
      ..birthDate = fields[5] as DateTime
      ..gender = fields[6] as String
      ..state = fields[7] as String
      ..result = fields[8] as String
      ..createdAt = fields[9] as DateTime
      ..tool = (fields[10] as String?) ?? 'legacy';
  }

  @override
  void write(BinaryWriter writer, CalculationModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.lastName)
      ..writeByte(4)
      ..write(obj.secondLastName)
      ..writeByte(5)
      ..write(obj.birthDate)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.state)
      ..writeByte(8)
      ..write(obj.result)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.tool);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
