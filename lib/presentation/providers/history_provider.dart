import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:rfc_and_curp_helper/data/datasources/local_history_datasource.dart';
import 'package:rfc_and_curp_helper/data/repositories/history_repository_impl.dart';
import 'package:rfc_and_curp_helper/domain/entities/calculation_entity.dart';
import 'package:rfc_and_curp_helper/domain/repositories/history_repository.dart';
import 'package:rfc_and_curp_helper/domain/usecases/curp_calculator.dart';
import 'package:rfc_and_curp_helper/domain/usecases/rfc_calculator.dart';

final localHistoryDatasourceProvider = Provider<LocalHistoryDatasource>((ref) {
  return LocalHistoryDatasource();
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepositoryImpl(ref.watch(localHistoryDatasourceProvider));
});

final historyProvider =
    StateNotifierProvider<HistoryNotifier, AsyncValue<List<CalculationEntity>>>(
  (ref) => HistoryNotifier(ref.watch(historyRepositoryProvider)),
);

class HistoryNotifier extends StateNotifier<AsyncValue<List<CalculationEntity>>> {
  final HistoryRepository _repository;
  final _uuid = const Uuid();

  HistoryNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    final previous = state.valueOrNull;
    state = const AsyncValue.loading();
    try {
      final calculations = await _repository.getAllCalculations();
      state = AsyncValue.data(calculations);
    } catch (e, st) {
      if (previous != null) {
        state = AsyncValue.data(previous);
        return;
      }
      state = AsyncValue.error(e, st);
    }
  }

  Future<String> saveCurpCalculation({
    required String firstName,
    required String lastName,
    required String secondLastName,
    required DateTime birthDate,
    required String gender,
    required String birthState,
  }) async {
    final result = CurpCalculator.calculate(
      firstName: firstName,
      lastName: lastName,
      secondLastName: secondLastName,
      birthDate: birthDate,
      gender: gender,
      state: birthState,
    );

    final entity = CalculationEntity(
      id: _uuid.v4(),
      type: 'CURP',
      firstName: firstName,
      lastName: lastName,
      secondLastName: secondLastName,
      birthDate: birthDate,
      gender: gender,
      state: birthState,
      result: result,
      createdAt: DateTime.now(),
    );

    await _repository.saveCalculation(entity);
    final current = state.valueOrNull ?? const <CalculationEntity>[];
    state = AsyncValue.data([entity, ...current]);
    return result;
  }

  Future<String> saveRfcCalculation({
    required String firstName,
    required String lastName,
    required String secondLastName,
    required DateTime birthDate,
  }) async {
    final result = RfcCalculator.calculate(
      firstName: firstName,
      paternalLastName: lastName,
      maternalLastName: secondLastName,
      birthDate: birthDate,
    );

    final entity = CalculationEntity(
      id: _uuid.v4(),
      type: 'RFC',
      firstName: firstName,
      lastName: lastName,
      secondLastName: secondLastName,
      birthDate: birthDate,
      gender: '',
      state: '',
      result: result,
      createdAt: DateTime.now(),
    );

    await _repository.saveCalculation(entity);
    final current = state.valueOrNull ?? const <CalculationEntity>[];
    state = AsyncValue.data([entity, ...current]);
    return result;
  }

  Future<void> deleteCalculation(String id) async {
    await _repository.deleteCalculation(id);
    final current = state.valueOrNull ?? const <CalculationEntity>[];
    state = AsyncValue.data(current.where((item) => item.id != id).toList());
  }

  Future<void> clearHistory() async {
    await _repository.clearAllCalculations();
    state = const AsyncValue.data([]);
  }
}
