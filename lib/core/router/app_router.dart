import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rfc_and_curp_helper/presentation/screens/home/home_screen.dart';
import 'package:rfc_and_curp_helper/presentation/screens/curp_calculator/curp_calculator_screen.dart';
import 'package:rfc_and_curp_helper/presentation/screens/rfc_calculator/rfc_calculator_screen.dart';
import 'package:rfc_and_curp_helper/presentation/screens/history/history_screen.dart';
import 'package:rfc_and_curp_helper/presentation/screens/settings/settings_screen.dart';
import 'package:rfc_and_curp_helper/presentation/widgets/main_scaffold.dart';

class AppRoutes {
  static const String home = '/';
  static const String curpCalculator = '/curp-calculator';
  static const String rfcCalculator = '/rfc-calculator';
  static const String history = '/history';
  static const String settings = '/settings';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.history,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HistoryScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.settings,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.curpCalculator,
      builder: (context, state) => const CurpCalculatorScreen(),
    ),
    GoRoute(
      path: AppRoutes.rfcCalculator,
      builder: (context, state) => const RfcCalculatorScreen(),
    ),
  ],
);