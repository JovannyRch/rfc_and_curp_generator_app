import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rfc_and_curp_helper/core/constants/mexican_states.dart';
import 'package:rfc_and_curp_helper/domain/usecases/curp_calculator.dart';
import 'package:rfc_and_curp_helper/presentation/providers/ad_provider.dart';
import 'package:rfc_and_curp_helper/presentation/providers/history_provider.dart';
import 'package:rfc_and_curp_helper/presentation/providers/review_prompt_provider.dart';
import 'package:rfc_and_curp_helper/presentation/providers/settings_provider.dart';
import 'package:rfc_and_curp_helper/presentation/widgets/banner_ad_card.dart';
import 'package:rfc_and_curp_helper/presentation/widgets/result_card.dart';

enum _CurpMode { withData, random }

class CurpCalculatorScreen extends ConsumerStatefulWidget {
  const CurpCalculatorScreen({super.key});

  @override
  ConsumerState<CurpCalculatorScreen> createState() =>
      _CurpCalculatorScreenState();
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
  RandomCurpProfile? _randomProfile;
  bool _isLoading = false;
  _CurpMode _mode = _CurpMode.withData;

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
    if (_birthDate == null ||
        _selectedGender == null ||
        _selectedState == null) {
      final message = _birthDate == null
          ? 'selectBirthDate'.tr()
          : _selectedGender == null
          ? 'selectGender'.tr()
          : 'selectState'.tr();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await ref
          .read(historyProvider.notifier)
          .saveCurpCalculation(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            secondLastName: _secondLastNameController.text,
            birthDate: _birthDate!,
            gender: _selectedGender!,
            birthState: _selectedState!,
            tool: 'curp_calculator',
          );

      if (!mounted) return;
      setState(() {
        _result = result;
        _randomProfile = null;
      });
      await ref.read(adControllerProvider).trackCalculation();
      await ref
          .read(reviewPromptControllerProvider)
          .recordSuccessfulCalculation();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('calculationSaved'.tr())));
    } catch (_) {
      await ref.read(reviewPromptControllerProvider).markError();
      rethrow;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _generateRandom() async {
    setState(() => _isLoading = true);
    try {
      final profile = CurpCalculator.generateRandomProfile();
      final result = await ref
          .read(historyProvider.notifier)
          .saveCurpCalculation(
            firstName: profile.firstName,
            lastName: profile.lastName,
            secondLastName: profile.secondLastName,
            birthDate: profile.birthDate,
            gender: profile.gender,
            birthState: profile.state,
            tool: 'curp_random',
          );

      if (!mounted) return;
      setState(() {
        _result = result;
        _randomProfile = profile;
      });
      await ref.read(adControllerProvider).trackCalculation();
      await ref
          .read(reviewPromptControllerProvider)
          .recordSuccessfulCalculation();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('randomCurpGenerated'.tr())));
    } catch (_) {
      await ref.read(reviewPromptControllerProvider).markError();
      rethrow;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _copyResult() async {
    if (_result == null) return;
    await Clipboard.setData(ClipboardData(text: _result!));
    await ref.read(reviewPromptControllerProvider).recordResultEngagement();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('copied'.tr())));
    }
  }

  Future<void> _shareResult() async {
    if (_result == null) return;
    await Share.share(_result!);
    await ref.read(reviewPromptControllerProvider).recordResultEngagement();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final removeAds = ref.watch(removeAdsProvider);

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
          SegmentedButton<_CurpMode>(
            segments: [
              ButtonSegment<_CurpMode>(
                value: _CurpMode.withData,
                icon: const Icon(Icons.badge_outlined),
                label: Text('withData'.tr()),
              ),
              ButtonSegment<_CurpMode>(
                value: _CurpMode.random,
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
          const SizedBox(height: 20),
          if (_mode == _CurpMode.random)
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
                    'randomCurp'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'randomCurpDetail'.tr(),
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
                    label: Text('generateRandomCurp'.tr()),
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
                      'personalData'.tr(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
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
                        DropdownMenuItem(
                          value: 'MALE',
                          child: Text('male'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'FEMALE',
                          child: Text('female'.tr()),
                        ),
                        DropdownMenuItem(
                          value: 'NON_BINARY',
                          child: Text('nonBinary'.tr()),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedGender = value),
                      validator: (value) =>
                          value == null ? 'selectGender'.tr() : null,
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
                      onChanged: (value) =>
                          setState(() => _selectedState = value),
                      validator: (value) =>
                          value == null ? 'selectState'.tr() : null,
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
            if (!removeAds) const BannerAdCard(),
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
                      '${_randomProfile!.firstName} ${_randomProfile!.lastName} ${_randomProfile!.secondLastName}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DateFormat('dd/MM/yyyy').format(_randomProfile!.birthDate)}  •  ${_genderLabel(_randomProfile!.gender).tr()}  •  ${_randomProfile!.state}',
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

  String _genderLabel(String gender) {
    return switch (gender) {
      'MALE' => 'male',
      'FEMALE' => 'female',
      'NON_BINARY' => 'nonBinary',
      _ => gender,
    };
  }
}
