import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rfc_and_curp_helper/core/router/app_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location == AppRoutes.home) return 0;
    if (location == AppRoutes.history) return 1;
    if (location == AppRoutes.settings) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.history);
        break;
      case 2:
        context.go(AppRoutes.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          color: theme.navigationBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: theme.colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) => _onItemTapped(index, context),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: 'homeTitle'.tr(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.history_toggle_off_rounded),
                selectedIcon: const Icon(Icons.history_rounded),
                label: 'history'.tr(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.tune_outlined),
                selectedIcon: const Icon(Icons.tune_rounded),
                label: 'settings'.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
