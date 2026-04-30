import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rfc_and_curp_helper/core/router/app_router.dart';
import 'package:rfc_and_curp_helper/core/theme/app_theme.dart';
import 'package:rfc_and_curp_helper/data/models/calculation_model.dart';
import 'package:rfc_and_curp_helper/presentation/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    await MobileAds.instance.initialize();
  }

  await Hive.initFlutter();
  Hive.registerAdapter(CalculationModelAdapter());

  runApp(
    ProviderScope(
      child: EasyLocalization(
        path: 'assets/translations',
        fallbackLocale: const Locale('es'),
        supportedLocales: const [Locale('en'), Locale('es')],
        saveLocale: true,
        child: const RfcCurpApp(),
      ),
    ),
  );
}

class RfcCurpApp extends ConsumerWidget {
  const RfcCurpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Calculadora CURP y RFC',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      routerConfig: appRouter,
    );
  }
}
