import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rfc_and_curp_helper/domain/usecases/curp_calculator.dart';

class CurpValidatorScreen extends StatefulWidget {
  const CurpValidatorScreen({super.key});

  @override
  State<CurpValidatorScreen> createState() => _CurpValidatorScreenState();
}

class _CurpValidatorScreenState extends State<CurpValidatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _curpController = TextEditingController();

  String? _submittedCurp;
  bool? _isValid;

  @override
  void dispose() {
    _curpController.dispose();
    super.dispose();
  }

  void _validateCurp() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final normalized = _curpController.text.trim().toUpperCase();
    setState(() {
      _submittedCurp = normalized;
      _isValid = CurpCalculator.validate(normalized);
    });
  }

  Future<void> _copyResult() async {
    if (_submittedCurp == null) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: _submittedCurp!));
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
        title: Text('curpValidator'.tr()),
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
                  'curpValidator'.tr(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'curpValidatorDetail'.tr(),
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
                    'curpInputLabel'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _curpController,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                      LengthLimitingTextInputFormatter(18),
                    ],
                    decoration: InputDecoration(
                      labelText: 'curp'.tr(),
                      prefixIcon: const Icon(Icons.verified_user_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'enterCurp'.tr();
                      }
                      if (value.trim().length != 18) {
                        return 'curpMustHave18Chars'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _validateCurp,
                    icon: const Icon(Icons.fact_check_outlined),
                    label: Text('validateCurp'.tr()),
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
                              ? 'validCurp'.tr()
                              : 'invalidCurp'.tr(),
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
                    _submittedCurp!,
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
                        ? 'curpValidationSuccess'.tr()
                        : 'curpValidationFailure'.tr(),
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
