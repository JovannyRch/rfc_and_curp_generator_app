import 'package:flutter/material.dart';

class AppTheme {
  static const Color neutralBlack = Color(0xFF161A1D);
  static const Color burgundy = Color(0xFF9B2247);
  static const Color green = Color(0xFF1E5B4F);
  static const Color coolGray = Color(0xFF98989A);
  static const Color darkBurgundy = Color(0xFF611232);
  static const Color darkGreen = Color(0xFF002F2A);
  static const Color lightCanvas = Color(0xFFF7F3EA);
  static const Color lightSurface = Color(0xFFFFFCF8);
  static const Color lightSurfaceAlt = Color(0xFFF2ECE8);
  static const Color darkSurface = Color(0xFF0F1413);
  static const Color darkSurfaceAlt = Color(0xFF16201E);

  static ThemeData lightTheme = _buildTheme(brightness: Brightness.light);
  static ThemeData darkTheme = _buildTheme(brightness: Brightness.dark);

  static ThemeData _buildTheme({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: green,
      onPrimary: Colors.white,
      primaryContainer: isDark
          ? const Color(0xFF114139)
          : const Color(0xFFD4E3D9),
      onPrimaryContainer: isDark ? const Color(0xFFE0F1EA) : darkGreen,
      secondary: burgundy,
      onSecondary: Colors.white,
      secondaryContainer: isDark
          ? const Color(0xFF4A1227)
          : const Color(0xFFF1D3DD),
      onSecondaryContainer: isDark ? const Color(0xFFF8DDE7) : darkBurgundy,
      tertiary: burgundy,
      onTertiary: Colors.white,
      tertiaryContainer: isDark
          ? const Color(0xFF4A1227)
          : const Color(0xFFF1D3DD),
      onTertiaryContainer: isDark ? const Color(0xFFF8DDE7) : darkBurgundy,
      error: const Color(0xFFB3261E),
      onError: Colors.white,
      errorContainer: const Color(0xFFF9DEDC),
      onErrorContainer: const Color(0xFF410E0B),
      surface: isDark ? darkSurfaceAlt : lightSurface,
      onSurface: isDark ? const Color(0xFFF4EFE3) : neutralBlack,
      surfaceContainerLowest: isDark ? const Color(0xFF0B100F) : Colors.white,
      surfaceContainerLow: isDark
          ? const Color(0xFF121918)
          : const Color(0xFFFCF8F1),
      surfaceContainer: isDark
          ? const Color(0xFF182120)
          : const Color(0xFFF7F0E1),
      surfaceContainerHigh: isDark
          ? const Color(0xFF1C2624)
          : const Color(0xFFF0E7D7),
      surfaceContainerHighest: isDark
          ? const Color(0xFF22302D)
          : lightSurfaceAlt,
      onSurfaceVariant: isDark
          ? const Color(0xFFC7C2B7)
          : const Color(0xFF5A5B57),
      outline: isDark ? const Color(0xFF42504D) : const Color(0xFFD8CCB0),
      outlineVariant: isDark
          ? const Color(0xFF2B3634)
          : const Color(0xFFE6DBC2),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: isDark ? const Color(0xFFECE6DA) : neutralBlack,
      onInverseSurface: isDark ? neutralBlack : Colors.white,
      inversePrimary: isDark ? const Color(0xFFA9D2C6) : darkGreen,
      surfaceTint: green,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? darkSurface : lightCanvas,
      visualDensity: VisualDensity.standard,
    );

    final textTheme = base.textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return base.copyWith(
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w800,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        titleSmall: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        bodyLarge: textTheme.bodyLarge?.copyWith(height: 1.45),
        bodyMedium: textTheme.bodyMedium?.copyWith(height: 1.45),
        labelLarge: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.08),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? colorScheme.surfaceContainerLow : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        prefixIconColor: colorScheme.primary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark
            ? colorScheme.surfaceContainerHighest
            : neutralBlack,
        contentTextStyle: TextStyle(
          color: isDark ? colorScheme.onSurface : Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          backgroundColor: isDark
              ? colorScheme.surfaceContainerLow
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark
            ? const Color(0xFF111818)
            : const Color(0xFFFFFBF4),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 76,
        indicatorColor: isDark
            ? const Color(0xFF294C46)
            : const Color(0xFFD9E8DF),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.tertiary
              : colorScheme.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary.withValues(alpha: 0.6)
              : colorScheme.surfaceContainerHighest,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    );
  }
}
