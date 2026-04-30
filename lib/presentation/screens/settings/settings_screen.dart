import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rfc_and_curp_helper/presentation/providers/review_prompt_provider.dart';
import 'package:rfc_and_curp_helper/presentation/providers/settings_provider.dart';
import 'package:rfc_and_curp_helper/presentation/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final premiumState = ref.watch(premiumControllerProvider);
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.primaryContainer,
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
                  'settings'.tr(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'settingsSubtitle'.tr(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SettingsGroup(
            title: 'language'.tr(),
            children: [
              _SettingsTile(
                icon: Icons.language_rounded,
                title: 'language'.tr(),
                subtitle: _languageLabel(context.locale.languageCode).tr(),
                onTap: () => _showLanguageSheet(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsGroup(
            title: 'theme'.tr(),
            children: [
              _SettingsTile(
                icon: Icons.palette_outlined,
                title: 'theme'.tr(),
                subtitle: _themeLabel(themeMode).tr(),
                onTap: () => _showThemeSheet(context, ref, themeMode),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsGroup(
            title: 'premiumLifetime'.tr(),
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.workspace_premium_outlined),
                title: Text('premiumLifetime'.tr()),
                subtitle: Text(
                  premiumState.isPremium
                      ? 'premiumBenefitsActive'.tr()
                      : premiumState.productDetails?.price ??
                            'premiumUnavailable'.tr(),
                ),
                trailing: premiumState.isPremium
                    ? Icon(
                        Icons.check_circle_rounded,
                        color: theme.colorScheme.primary,
                      )
                    : premiumState.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                'premiumBenefits'.tr(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed:
                          premiumState.isPremium ||
                              premiumState.isLoading ||
                              premiumState.productDetails == null
                          ? null
                          : () => ref
                                .read(premiumControllerProvider.notifier)
                                .purchasePremium(),
                      icon: const Icon(Icons.lock_open_rounded),
                      label: Text('unlockPremium'.tr()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: premiumState.isLoading
                          ? null
                          : () => ref
                                .read(premiumControllerProvider.notifier)
                                .restorePurchases(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text('restorePurchases'.tr()),
                    ),
                  ),
                ],
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.star_outline_rounded,
                title: 'rateApp'.tr(),
                subtitle: 'rateAppDesc'.tr(),
                onTap: () =>
                    ref.read(reviewPromptControllerProvider).requestReviewNow(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsGroup(
            title: 'aboutApp'.tr(),
            children: [
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'version'.tr(),
                subtitle: '1.0.0',
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'lightMode',
      ThemeMode.dark => 'darkMode',
      ThemeMode.system => 'system',
    };
  }

  String _languageLabel(String code) {
    return switch (code) {
      'es' => 'spanish',
      _ => 'english',
    };
  }

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'language'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                title: Text('english'.tr()),
                trailing: context.locale.languageCode == 'en'
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () async {
                  await context.setLocale(const Locale('en'));
                  if (sheetContext.mounted) Navigator.pop(sheetContext);
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                title: Text('spanish'.tr()),
                trailing: context.locale.languageCode == 'es'
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () async {
                  await context.setLocale(const Locale('es'));
                  if (sheetContext.mounted) Navigator.pop(sheetContext);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeSheet(
    BuildContext context,
    WidgetRef ref,
    ThemeMode currentMode,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('theme'.tr(), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              ...ThemeMode.values.map(
                (mode) => ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  title: Text(_themeLabel(mode).tr()),
                  trailing: currentMode == mode
                      ? const Icon(Icons.check_rounded)
                      : null,
                  onTap: () async {
                    await ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(mode);
                    if (sheetContext.mounted) Navigator.pop(sheetContext);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
