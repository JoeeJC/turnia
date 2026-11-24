import 'package:flutter/material.dart';

/// Paleta de colores Turnia: Rose (primario) y Teal (secundario/acento).
/// Diseñada para contraste accesible (WCAG AA/AAA en combinación con
/// superficies claras y oscuras).
abstract class TurniaPalette {
  static const Color rose50 = Color(0xFFFDF2F4);
  static const Color rose100 = Color(0xFFFCE7EC);
  static const Color rose400 = Color(0xFFEC4899);
  static const Color rose500 = Color(0xFFE91E63);
  static const Color rose600 = Color(0xFFC2185B);
  static const Color rose900 = Color(0xFF880E4F);

  static const Color teal50 = Color(0xFFF0FDFA);
  static const Color teal100 = Color(0xFFCCFBFA);
  static const Color teal400 = Color(0xFF2DD4BF);
  static const Color teal500 = Color(0xFF00ACC1);
  static const Color teal600 = Color(0xFF00838F);
  static const Color teal900 = Color(0xFF004D40);

  static const Color surfaceRose = Color(0xFFFDF2F4);
  static const Color surfaceTeal = Color(0xFFF0FDFA);
}

/// Esquema de color claro (Material 3) basado en Rose/Teal.
final ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: TurniaPalette.rose500,
  onPrimary: Colors.white,
  primaryContainer: TurniaPalette.rose100,
  onPrimaryContainer: TurniaPalette.rose900,
  secondary: TurniaPalette.teal500,
  onSecondary: Colors.white,
  secondaryContainer: TurniaPalette.teal100,
  onSecondaryContainer: TurniaPalette.teal900,
  tertiary: TurniaPalette.rose600,
  onTertiary: Colors.white,
  error: Colors.redAccent,
  onError: Colors.white,
  surface: Colors.white,
  onSurface: Colors.black87,
  outline: TurniaPalette.rose400.withValues(alpha: 0.3),
);

/// Esquema de color oscuro (Material 3) basado en Rose/Teal.
final ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: TurniaPalette.rose400,
  onPrimary: Colors.black,
  primaryContainer: TurniaPalette.rose900,
  onPrimaryContainer: TurniaPalette.rose100,
  secondary: TurniaPalette.teal400,
  onSecondary: Colors.black,
  secondaryContainer: TurniaPalette.teal900,
  onSecondaryContainer: TurniaPalette.teal100,
  tertiary: TurniaPalette.rose400,
  onTertiary: Colors.black,
  error: Colors.redAccent,
  onError: Colors.black,
  surface: Color(0xFF121212),
  onSurface: Colors.white,
  outline: TurniaPalette.teal400.withValues(alpha: 0.3),
);

/// Tema claro de Turnia (Material 3).
ThemeData get lightTheme {
  return ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      foregroundColor: lightColorScheme.onPrimary,
      backgroundColor: lightColorScheme.primary,
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightColorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: lightColorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: lightColorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.black87,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

/// Tema oscuro de Turnia (Material 3).
ThemeData get darkTheme {
  return ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      foregroundColor: darkColorScheme.onPrimary,
      backgroundColor: darkColorScheme.primary,
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkColorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: darkColorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: darkColorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey[800],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}