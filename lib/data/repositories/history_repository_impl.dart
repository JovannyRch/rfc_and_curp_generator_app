import 'package:rfc_and_curp_helper/data/datasources/local_history_datasource.dart';
import 'package:rfc_and_curp_helper/data/models/calculation_model.dart';
import 'package:rfc_and_curp_helper/domain/entities/calculation_entity.dart';
import 'package:rfc_and_curp_helper/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final LocalHistoryDatasource _datasource;

  HistoryRepositoryImpl(this._datasource);

  @override
  Future<List<CalculationEntity>> getAllCalculations() async {
    final models = await _datasource.getAllCalculations();
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<void> saveCalculation(CalculationEntity calculation) async {
    final model = _entityToModel(calculation);
    await _datasource.saveCalculation(model);
  }

  @override
  Future<void> deleteCalculation(String id) async {
    await _datasource.deleteCalculation(id);
  }

  @override
  Future<void> clearAllCalculations() async {
    await _datasource.clearAllCalculations();
  }

  CalculationEntity _modelToEntity(CalculationModel model) {
    return CalculationEntity(
      id: model.id,
      type: model.type,
      firstName: model.firstName,
      lastName: model.lastName,
      secondLastName: model.secondLastName,
      birthDate: model.birthDate,
      gender: model.gender,
      state: model.state,
      result: model.result,
      tool: model.tool,
      createdAt: model.createdAt,
    );
  }

  CalculationModel _entityToModel(CalculationEntity entity) {
    return CalculationModel.create(
      id: entity.id,
      type: entity.type,
      firstName: entity.firstName,
      lastName: entity.lastName,
      secondLastName: entity.secondLastName,
      birthDate: entity.birthDate,
      gender: entity.gender,
      state: entity.state,
      result: entity.result,
      createdAt: entity.createdAt,
      tool: entity.tool,
    );
  }
}
