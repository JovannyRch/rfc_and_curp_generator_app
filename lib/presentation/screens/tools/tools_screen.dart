import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rfc_and_curp_helper/core/router/app_router.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'tools'.tr(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'toolsSubtitle'.tr(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _ToolSection(
            title: 'curpSection'.tr(),
            children: [
              _ToolTile(
                icon: Icons.badge_outlined,
                accent: theme.colorScheme.primary,
                title: 'curpCalculator'.tr(),
                subtitle: 'curpHeroDetail'.tr(),
                onTap: () => context.push(AppRoutes.curpCalculator),
              ),
              _ToolTile(
                icon: Icons.shuffle_rounded,
                accent: theme.colorScheme.primary,
                title: 'randomCurp'.tr(),
                subtitle: 'randomCurpDetail'.tr(),
                onTap: () => context.push(AppRoutes.curpCalculator),
              ),
              _ToolTile(
                icon: Icons.fact_check_outlined,
                accent: theme.colorScheme.primary,
                title: 'curpValidator'.tr(),
                subtitle: 'curpValidatorDetail'.tr(),
                onTap: () => context.push(AppRoutes.curpValidator),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _ToolSection(
            title: 'rfcSection'.tr(),
            children: [
              _ToolTile(
                icon: Icons.person_outline_rounded,
                accent: theme.colorScheme.tertiary,
                title: 'rfcCalculator'.tr(),
                subtitle: 'rfcHeroDetail'.tr(),
                onTap: () => context.push(AppRoutes.rfcCalculator),
              ),
              _ToolTile(
                icon: Icons.shuffle_rounded,
                accent: theme.colorScheme.tertiary,
                title: 'randomRfc'.tr(),
                subtitle: 'randomRfcDetail'.tr(),
                onTap: () => context.push(AppRoutes.rfcCalculator),
              ),
              _ToolTile(
                icon: Icons.business_outlined,
                accent: theme.colorScheme.tertiary,
                title: 'moralPerson'.tr(),
                subtitle: 'rfcMoralDetail'.tr(),
                onTap: () => context.push(AppRoutes.rfcCalculator),
              ),
              _ToolTile(
                icon: Icons.fact_check_outlined,
                accent: theme.colorScheme.tertiary,
                title: 'rfcValidator'.tr(),
                subtitle: 'rfcValidatorDetail'.tr(),
                onTap: () => context.push(AppRoutes.rfcValidator),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _ToolSection extends StatelessWidget {
  const _ToolSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({
    required this.icon,
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: accent),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_rounded, color: accent),
      ),
    );
  }
}
