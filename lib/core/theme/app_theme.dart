import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppThemes {
  // --- Light Theme ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: LightColors.primary,
    scaffoldBackgroundColor: LightColors.background,
    colorScheme: ColorScheme.light(
      primary: LightColors.primary,
      onPrimary: LightColors.onPrimary,
      secondary: LightColors.secondary,
      onSecondary: LightColors.onSecondary,
      background: LightColors.background,
      onBackground: LightColors.onBackground,
      surface: LightColors.surface,
      onSurface: LightColors.onSurface,
      error: LightColors.error,
      onError: LightColors.onError,
    ),
    elevatedButtonTheme:
        _elevatedButtonTheme(LightColors.primary, LightColors.onPrimary),
    textButtonTheme: _textButtonTheme(LightColors.primary),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: LightColors.accent,
      foregroundColor: LightColors.onAccent,
    ),
    textTheme: GoogleFonts.dmSansTextTheme()
  );

  // --- Dark Theme ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: DarkColors.primary,
    scaffoldBackgroundColor: DarkColors.background,
    colorScheme: ColorScheme.dark(
      primary: DarkColors.primary,
      onPrimary: DarkColors.onPrimary,
      secondary: DarkColors.secondary,
      onSecondary: DarkColors.onSecondary,
      background: DarkColors.background,
      onBackground: DarkColors.onBackground,
      surface: DarkColors.surface,
      onSurface: DarkColors.onSurface,
      error: DarkColors.error,
      onError: DarkColors.onError,
    ),
    elevatedButtonTheme:
        _elevatedButtonTheme(DarkColors.primary, DarkColors.onPrimary),
    textButtonTheme: _textButtonTheme(DarkColors.primary),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: DarkColors.accent,
      foregroundColor: DarkColors.onAccent,
    ),
      textTheme: GoogleFonts.dmSansTextTheme()
  );

  // --- Private helpers ---
  static ElevatedButtonThemeData _elevatedButtonTheme(
      Color bgColor, Color fgColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(Color fgColor) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: fgColor,
      ),
    );
  }
}
