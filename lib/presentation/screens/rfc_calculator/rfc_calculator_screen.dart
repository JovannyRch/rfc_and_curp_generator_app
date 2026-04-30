import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rfc_and_curp_helper/domain/usecases/rfc_calculator.dart';
import 'package:rfc_and_curp_helper/presentation/providers/history_provider.dart';
import 'package:rfc_and_curp_helper/presentation/widgets/result_card.dart';

enum _RfcMode { withData, random }

enum _RfcPersonType { natural, moral }

class RfcCalculatorScreen extends ConsumerStatefulWidget {
  const RfcCalculatorScreen({super.key});

  @override
  ConsumerState<RfcCalculatorScreen> createState() =>
      _RfcCalculatorScreenState();
}

class _RfcCalculatorScreenState extends ConsumerState<RfcCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _secondLastNameController = TextEditingController();
  final _legalNameController = TextEditingController();

  DateTime? _birthDate;
  String? _result;
  RandomRfcProfile? _randomProfile;
  bool _isLoading = false;
  _RfcMode _mode = _RfcMode.withData;
  _RfcPersonType _personType = _RfcPersonType.natural;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _secondLastNameController.dispose();
    _legalNameController.dispose();
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
    if (_personType == _RfcPersonType.moral) {
      await _calculateMoral();
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('selectBirthDate'.tr())));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await ref
          .read(historyProvider.notifier)
          .saveRfcCalculation(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            secondLastName: _secondLastNameController.text,
            birthDate: _birthDate!,
            tool: 'rfc_calculator',
          );

      if (!mounted) return;
      setState(() {
        _result = result;
        _randomProfile = null;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('calculationSaved'.tr())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _calculateMoral() async {
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('selectCreationDate'.tr())));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await ref
          .read(historyProvider.notifier)
          .saveRfcMoralCalculation(
            legalName: _legalNameController.text,
            creationDate: _birthDate!,
            tool: 'rfc_moral',
          );

      if (!mounted) return;
      setState(() {
        _result = result;
        _randomProfile = null;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('calculationSaved'.tr())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _generateRandom() async {
    setState(() => _isLoading = true);
    try {
      final profile = RfcCalculator.generateRandomProfile();
      final result = await ref
          .read(historyProvider.notifier)
          .saveRfcCalculation(
            firstName: profile.firstName,
            lastName: profile.paternalLastName,
            secondLastName: profile.maternalLastName,
            birthDate: profile.birthDate,
            tool: 'rfc_random',
          );

      if (!mounted) return;
      setState(() {
        _result = result;
        _randomProfile = profile;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('randomRfcGenerated'.tr())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _copyResult() async {
    if (_result == null) return;
    await Clipboard.setData(ClipboardData(text: _result!));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('copied'.tr())));
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
        title: Text('rfcCalculator'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.tertiaryContainer,
                  theme.colorScheme.surfaceContainerHighest,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'rfcCalculator'.tr(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'rfcHeroDetail'.tr(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SegmentedButton<_RfcPersonType>(
            segments: [
              ButtonSegment<_RfcPersonType>(
                value: _RfcPersonType.natural,
                icon: const Icon(Icons.person_outline_rounded),
                label: Text('naturalPerson'.tr()),
              ),
              ButtonSegment<_RfcPersonType>(
                value: _RfcPersonType.moral,
                icon: const Icon(Icons.business_outlined),
                label: Text('moralPerson'.tr()),
              ),
            ],
            selected: {_personType},
            onSelectionChanged: (selection) {
              setState(() {
                _personType = selection.first;
                if (_personType == _RfcPersonType.moral) {
                  _mode = _RfcMode.withData;
                }
              });
            },
          ),
          const SizedBox(height: 20),
          if (_personType == _RfcPersonType.natural)
            SegmentedButton<_RfcMode>(
              segments: [
                ButtonSegment<_RfcMode>(
                  value: _RfcMode.withData,
                  icon: const Icon(Icons.badge_outlined),
                  label: Text('withData'.tr()),
                ),
                ButtonSegment<_RfcMode>(
                  value: _RfcMode.random,
                  icon: const Icon(Icons.shuffle_rounded),
                  label: Text('random'.tr()),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (selection) {
                setState(() {
                  _mode = selection.first;
                });
              },
            ),
          if (_personType == _RfcPersonType.natural) const SizedBox(height: 20),
          if (_personType == _RfcPersonType.natural && _mode == _RfcMode.random)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: theme.colorScheme.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'randomRfc'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'randomRfcDetail'.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _generateRandom,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.shuffle_rounded),
                    label: Text('generateRandomRfc'.tr()),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: theme.colorScheme.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _personType == _RfcPersonType.moral
                          ? 'legalEntityData'.tr()
                          : 'personalData'.tr(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_personType == _RfcPersonType.moral) ...[
                      TextFormField(
                        controller: _legalNameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'legalName'.tr(),
                          prefixIcon: const Icon(Icons.business_outlined),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'enterLegalName'.tr()
                            : null,
                      ),
                    ] else ...[
                      TextFormField(
                        controller: _firstNameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'firstName'.tr(),
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'enterFirstName'.tr()
                            : null,
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
                            value == null || value.trim().isEmpty
                            ? 'enterLastName'.tr()
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _secondLastNameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'secondLastName'.tr(),
                          prefixIcon: const Icon(Icons.badge_outlined),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'enterSecondLastName'.tr()
                            : null,
                      ),
                    ],
                    const SizedBox(height: 14),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: _selectBirthDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: _personType == _RfcPersonType.moral
                              ? 'creationDate'.tr()
                              : 'birthDate'.tr(),
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                        ),
                        child: Text(
                          _birthDate == null
                              ? _personType == _RfcPersonType.moral
                                    ? 'selectCreationDate'.tr()
                                    : 'selectBirthDate'.tr()
                              : DateFormat('dd/MM/yyyy').format(_birthDate!),
                        ),
                      ),
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
              title: 'rfcResult'.tr(),
              result: _result!,
              onCopy: _copyResult,
              onShare: _shareResult,
            ),
            if (_randomProfile != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'generatedProfile'.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${_randomProfile!.firstName} ${_randomProfile!.paternalLastName} ${_randomProfile!.maternalLastName}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat(
                        'dd/MM/yyyy',
                      ).format(_randomProfile!.birthDate),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
