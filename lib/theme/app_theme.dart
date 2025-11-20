// lib/theme/app_theme.dart
// Complete Flutter Theme Configuration for Flutter Shopping App Dark Theme
// Optimized for e-commerce mobile applications

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  /// Complete dark theme configuration for Flutter Shopping App - Portfolio Project by Frangel Barrera
  static ThemeData get darkTheme {
    return ThemeData(
      // === CORE CONFIGURATION ===
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: AppColors.darkColorScheme,

      // === VISUAL DENSITY ===
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // === APP BAR THEME ===
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.elevation4dp,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 4,
        centerTitle: false,
        titleSpacing: 16,
        toolbarHeight: 64,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
          letterSpacing: 0.15,
        ),
        iconTheme: IconThemeData(
          color: AppColors.onSurface,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: AppColors.onSurface,
          size: 24,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),

      // === CARD THEME ===
      cardTheme: CardTheme(
        color: AppColors.surface,
        surfaceTintColor: AppColors.primary,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      ),

      // === ELEVATED BUTTON THEME ===
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.onSurface.withOpacity(0.12),
          disabledForegroundColor: AppColors.onSurface.withOpacity(0.38),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: Size(64, 40),
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // === OUTLINED BUTTON THEME ===
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.onSurface.withOpacity(0.38),
          side: BorderSide(
            color: AppColors.primary,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: Size(64, 40),
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // === TEXT BUTTON THEME ===
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.onSurface.withOpacity(0.38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: Size(64, 36),
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // === FLOATING ACTION BUTTON THEME ===
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 6,
        highlightElevation: 12,
        splashColor: AppColors.onPrimary.withOpacity(0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // === INPUT DECORATION THEME ===
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.secondary.withOpacity(0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.secondary.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        hintStyle: TextStyle(
          color: AppColors.onSurfaceSecondary,
          fontSize: 16,
        ),
        labelStyle: TextStyle(
          color: AppColors.onSurfaceSecondary,
          fontSize: 16,
        ),
        floatingLabelStyle: TextStyle(
          color: AppColors.primary,
          fontSize: 12,
        ),
        prefixIconColor: AppColors.onSurfaceSecondary,
        suffixIconColor: AppColors.onSurfaceSecondary,
      ),

      // === BOTTOM NAVIGATION BAR THEME ===
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.elevation16dp,
        elevation: 8,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceSecondary,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // === TEXT THEME ===
      textTheme: TextTheme(
        // Main titles
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w300,
          color: AppColors.onSurface,
          letterSpacing: -0.25,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w300,
          color: AppColors.onSurface,
          letterSpacing: 0,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurface,
          letterSpacing: 0,
        ),
        
        // Section titles
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
          letterSpacing: 0.15,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
          letterSpacing: 0.15,
        ),
        
        // Component titles
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
          letterSpacing: 0.1,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
          letterSpacing: 0.1,
        ),
        
        // Body text
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurface,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurface,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceSecondary,
          letterSpacing: 0.4,
        ),
        
        // Labels
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceSecondary,
          letterSpacing: 0.5,
        ),
      ),

      // === ICON THEME ===
      iconTheme: IconThemeData(
        color: AppColors.onSurface,
        size: 24,
      ),
      primaryIconTheme: IconThemeData(
        color: AppColors.onPrimary,
        size: 24,
      ),

      // === DIVIDER THEME ===
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // === CHIP THEME ===
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        disabledColor: AppColors.onSurface.withOpacity(0.12),
        selectedColor: AppColors.primary.withOpacity(0.12),
        secondarySelectedColor: AppColors.secondary.withOpacity(0.12),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: TextStyle(
          color: AppColors.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: TextStyle(
          color: AppColors.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        brightness: Brightness.dark,
        elevation: 2,
        pressElevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // === DIALOG THEME ===
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.elevation24dp,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurface,
        ),
      ),

      // === SNACK BAR THEME ===
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.elevation8dp,
        contentTextStyle: TextStyle(
          color: AppColors.onSurface,
          fontSize: 14,
        ),
        actionTextColor: AppColors.primary,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // === SCAFFOLD BACKGROUND COLOR ===
      scaffoldBackgroundColor: AppColors.background,
    );
  }
}
