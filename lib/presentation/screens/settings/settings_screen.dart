import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:rfc_and_curp_helper/presentation/providers/settings_provider.dart';
import 'package:rfc_and_curp_helper/presentation/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final removeAds = ref.watch(removeAdsProvider);
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
                  theme.colorScheme.secondaryContainer,
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
            title: 'removeAds'.tr(),
            children: [
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                secondary: const Icon(Icons.workspace_premium_outlined),
                title: Text('removeAds'.tr()),
                subtitle: Text(
                  removeAds ? 'premiumEnabled'.tr() : 'removeAdsDesc'.tr(),
                ),
                value: removeAds,
                onChanged: (value) async {
                  if (value && !removeAds) {
                    await ref
                        .read(removeAdsProvider.notifier)
                        .purchaseRemoveAds();
                  } else {
                    await ref
                        .read(removeAdsProvider.notifier)
                        .setRemoveAds(value);
                  }
                },
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.star_outline_rounded,
                title: 'rateApp'.tr(),
                subtitle: 'rateAppDesc'.tr(),
                onTap: _requestReview,
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

  Future<void> _requestReview() async {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
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
