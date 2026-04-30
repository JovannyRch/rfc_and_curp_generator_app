import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rfc_and_curp_helper/core/constants/mexican_states.dart';
import 'package:rfc_and_curp_helper/presentation/providers/history_provider.dart';
import 'package:rfc_and_curp_helper/presentation/widgets/result_card.dart';

class CurpCalculatorScreen extends ConsumerStatefulWidget {
  const CurpCalculatorScreen({super.key});

  @override
  ConsumerState<CurpCalculatorScreen> createState() => _CurpCalculatorScreenState();
}

class _CurpCalculatorScreenState extends ConsumerState<CurpCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _secondLastNameController = TextEditingController();

  DateTime? _birthDate;
  String? _selectedGender;
  String? _selectedState;
  String? _result;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _secondLastNameController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null || _selectedGender == null || _selectedState == null) {
      final message = _birthDate == null
          ? 'selectBirthDate'.tr()
          : _selectedGender == null
              ? 'selectGender'.tr()
              : 'selectState'.tr();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await ref.read(historyProvider.notifier).saveCurpCalculation(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            secondLastName: _secondLastNameController.text,
            birthDate: _birthDate!,
            gender: _selectedGender!,
            birthState: _selectedState!,
          );

      if (!mounted) return;
      setState(() => _result = result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('calculationSaved'.tr())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _copyResult() async {
    if (_result == null) return;
    await Clipboard.setData(ClipboardData(text: _result!));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('copied'.tr())),
      );
    }
  }

  Future<void> _shareResult() async {
    if (_result == null) return;
    await Share.share(_result!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('curpCalculator'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.surfaceContainerHighest,
                ],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'curpCalculator'.tr(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'curpHeroDetail'.tr(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'personalData'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _firstNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'firstName'.tr(),
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                    ),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'enterFirstName'.tr() : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _lastNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'lastName'.tr(),
                      prefixIcon: const Icon(Icons.badge_outlined),
                    ),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'enterLastName'.tr() : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _secondLastNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'secondLastName'.tr(),
                      prefixIcon: const Icon(Icons.badge_outlined),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'enterSecondLastName'.tr()
                        : null,
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: _selectBirthDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'birthDate'.tr(),
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                      ),
                      child: Text(
                        _birthDate == null
                            ? 'selectBirthDate'.tr()
                            : DateFormat('dd/MM/yyyy').format(_birthDate!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedGender,
                    decoration: InputDecoration(
                      labelText: 'gender'.tr(),
                      prefixIcon: const Icon(Icons.wc_rounded),
                    ),
                    items: [
                      DropdownMenuItem(value: 'MALE', child: Text('male'.tr())),
                      DropdownMenuItem(value: 'FEMALE', child: Text('female'.tr())),
                    ],
                    onChanged: (value) => setState(() => _selectedGender = value),
                    validator: (value) => value == null ? 'selectGender'.tr() : null,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedState,
                    decoration: InputDecoration(
                      labelText: 'state'.tr(),
                      prefixIcon: const Icon(Icons.location_on_outlined),
                    ),
                    items: MexicanStates.states
                        .map(
                          (state) => DropdownMenuItem<String>(
                            value: state['name'],
                            child: Text(state['name']!),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _selectedState = value),
                    validator: (value) => value == null ? 'selectState'.tr() : null,
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _calculate,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_awesome_rounded),
                    label: Text('calculate'.tr()),
                  ),
                ],
              ),
            ),
          ),
          if (_result != null) ...[
            const SizedBox(height: 20),
            ResultCard(
              title: 'curpResult'.tr(),
              result: _result!,
              onCopy: _copyResult,
              onShare: _shareResult,
            ),
          ],
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
