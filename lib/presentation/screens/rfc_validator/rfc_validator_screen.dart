import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rfc_and_curp_helper/domain/usecases/rfc_calculator.dart';

class RfcValidatorScreen extends StatefulWidget {
  const RfcValidatorScreen({super.key});

  @override
  State<RfcValidatorScreen> createState() => _RfcValidatorScreenState();
}

class _RfcValidatorScreenState extends State<RfcValidatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _rfcController = TextEditingController();

  String? _submittedRfc;
  bool? _isValid;

  @override
  void dispose() {
    _rfcController.dispose();
    super.dispose();
  }

  void _validateRfc() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final normalized = _rfcController.text.trim().toUpperCase();
    setState(() {
      _submittedRfc = normalized;
      _isValid = RfcCalculator.validate(normalized);
    });
  }

  Future<void> _copyResult() async {
    if (_submittedRfc == null) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: _submittedRfc!));
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('copied'.tr())));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final validationPassed = _isValid == true;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('rfcValidator'.tr()),
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
                  'rfcValidator'.tr(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'rfcValidatorDetail'.tr(),
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
                    'rfcInputLabel'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _rfcController,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[A-Za-z0-9&Ññ]'),
                      ),
                      LengthLimitingTextInputFormatter(13),
                    ],
                    decoration: InputDecoration(
                      labelText: 'rfc'.tr(),
                      prefixIcon: const Icon(Icons.verified_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'enterRfc'.tr();
                      }
                      final length = value.trim().length;
                      if (length != 12 && length != 13) {
                        return 'rfcMustHave12Or13Chars'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _validateRfc,
                    icon: const Icon(Icons.fact_check_outlined),
                    label: Text('validateRfc'.tr()),
                  ),
                ],
              ),
            ),
          ),
          if (_isValid != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: validationPassed
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        validationPassed
                            ? Icons.verified_rounded
                            : Icons.error_outline_rounded,
                        color: validationPassed
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onTertiaryContainer,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          validationPassed
                              ? 'validRfc'.tr()
                              : 'invalidRfc'.tr(),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: validationPassed
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onTertiaryContainer,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    _submittedRfc!,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: validationPassed
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    validationPassed
                        ? 'rfcValidationSuccess'.tr()
                        : 'rfcValidationFailure'.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: validationPassed
                          ? theme.colorScheme.onPrimaryContainer.withValues(
                              alpha: 0.82,
                            )
                          : theme.colorScheme.onTertiaryContainer.withValues(
                              alpha: 0.82,
                            ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    onPressed: _copyResult,
                    icon: const Icon(Icons.copy_rounded),
                    label: Text('copy'.tr()),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
