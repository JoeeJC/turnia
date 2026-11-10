import 'package:flutter/material.dart';

/// Paleta de marca de Turnia.
class Brand {
  static const Color violet = Color(0xFF7C5CFF);
  static const Color violetDark = Color(0xFF5B3FD9);
  static const Color pink = Color(0xFFFF6FA5);
  static const Color teal = Color(0xFF20C4B0);
  static const Color ink = Color(0xFF15131F);
  static const Color inkSoft = Color(0xFF5B5875);
  static const Color bg = Color(0xFFF6F5FB);
  static const Color surface = Colors.white;
  static const Color line = Color(0xFFECEAF5);
  static const Color danger = Color(0xFFEF4444);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [violet, violetDark],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B6CFF), Color(0xFF6A46E6)],
  );
}

ThemeData buildTheme({bool dark = false}) {
  final base = dark ? ThemeData.dark() : ThemeData.light();

  final scheme = ColorScheme.fromSeed(
    seedColor: Brand.violet,
    brightness: dark ? Brightness.dark : Brightness.light,
  );

  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: dark ? const Color(0xFF100F18) : Brand.bg,
    splashFactory: InkRipple.splashFactory,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      foregroundColor: dark ? Colors.white : Brand.ink,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: dark ? Colors.white : Brand.ink,
      ),
    ),
    textTheme: base.textTheme.apply(
      bodyColor: dark ? Colors.white : Brand.ink,
      displayColor: dark ? Colors.white : Brand.ink,
      fontFamily: 'Inter',
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? const Color(0xFF1B1A26) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(color: Color(0xFF9A97B0)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: dark ? const Color(0xFF2A2838) : Brand.line, width: 1.4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Brand.violet, width: 1.8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Brand.violet,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
  );
}