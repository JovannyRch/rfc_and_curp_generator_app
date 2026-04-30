import 'package:hive/hive.dart';
import 'package:rfc_and_curp_helper/data/models/calculation_model.dart';

class LocalHistoryDatasource {
  static const String boxName = 'calculations';

  Future<Box<CalculationModel>> _getBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<CalculationModel>(boxName);
    }
    return Hive.box<CalculationModel>(boxName);
  }

  Future<List<CalculationModel>> getAllCalculations() async {
    final box = await _getBox();
    return box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> saveCalculation(CalculationModel calculation) async {
    final box = await _getBox();
    await box.put(calculation.id, calculation);
  }

  Future<void> deleteCalculation(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  Future<void> clearAllCalculations() async {
    final box = await _getBox();
    await box.clear();
  }
}