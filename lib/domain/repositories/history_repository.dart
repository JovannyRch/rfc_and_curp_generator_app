import 'package:rfc_and_curp_helper/domain/entities/calculation_entity.dart';

abstract class HistoryRepository {
  Future<List<CalculationEntity>> getAllCalculations();
  Future<void> saveCalculation(CalculationEntity calculation);
  Future<void> deleteCalculation(String id);
  Future<void> clearAllCalculations();
}