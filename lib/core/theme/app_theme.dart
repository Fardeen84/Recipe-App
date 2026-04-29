import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary warm palette
  static const primary    = Color(0xFFE8572A);
  static const primarySoft= Color(0xFFFF7F50);
  static const accent     = Color(0xFFFFB347);
  static const accentGreen= Color(0xFF2ECC71);

  // Light
  static const lightBg      = Color(0xFFFFF8F2);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard    = Color(0xFFF5EDE4);
  static const lightBorder  = Color(0xFFEDD5BC);

  // Dark
  static const darkBg      = Color(0xFF0F0E0D);
  static const darkSurface = Color(0xFF1C1A18);
  static const darkCard    = Color(0xFF272421);
  static const darkBorder  = Color(0xFF3A3330);

  static const textPrimary   = Color(0xFF1A1208);
  static const textSecondary = Color(0xFF7A6A58);
  static const textHint      = Color(0xFFB0A090);
}

class AppTheme {
  AppTheme._();

  static TextTheme _textTheme(Color base) => TextTheme(
    displayLarge:  GoogleFonts.playfairDisplay(fontSize: 34, fontWeight: FontWeight.w700, color: base),
    displayMedium: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w700, color: base),
    headlineLarge: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.w600, color: base),
    headlineMedium:GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w600, color: base),
    titleLarge:    GoogleFonts.nunito(fontSize: 17, fontWeight: FontWeight.w700, color: base),
    titleMedium:   GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600, color: base),
    titleSmall:    GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: base),
    bodyLarge:     GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w400, color: base),
    bodyMedium:    GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w400, color: base),
    bodySmall:     GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w400, color: base),
    labelLarge:    GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: base),
    labelMedium:   GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: base),
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    colorScheme: ColorScheme.light(
      primary:    AppColors.primary,
      secondary:  AppColors.accent,
      surface:    AppColors.lightSurface,
      background: AppColors.lightBg,
      onPrimary:  Colors.white,
      onSurface:  AppColors.textPrimary,
    ),
    textTheme: _textTheme(AppColors.textPrimary),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightCard,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      hintStyle: GoogleFonts.nunito(color: AppColors.textHint, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textHint,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      showUnselectedLabels: true,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: GoogleFonts.nunito(color: Colors.white, fontSize: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightCard,
      selectedColor: AppColors.primary,
      labelStyle: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.lightBorder, thickness: 1),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    colorScheme: ColorScheme.dark(
      primary:    AppColors.primarySoft,
      secondary:  AppColors.accent,
      surface:    AppColors.darkSurface,
      background: AppColors.darkBg,
      onPrimary:  Colors.white,
      onSurface:  Colors.white,
    ),
    textTheme: _textTheme(Colors.white),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primarySoft, width: 1.5),
      ),
      hintStyle: GoogleFonts.nunito(color: Colors.white38, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.primarySoft,
      unselectedItemColor: Colors.white38,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      showUnselectedLabels: true,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkCard,
      contentTextStyle: GoogleFonts.nunito(color: Colors.white, fontSize: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkCard,
      selectedColor: AppColors.primarySoft,
      labelStyle: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.darkBorder, thickness: 1),
  );
}
